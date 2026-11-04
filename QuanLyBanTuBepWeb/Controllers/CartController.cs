using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Helpers;
using QuanLyBanTuBepWeb.Models;
using QuanLyBanTuBepWeb.Models.ViewModels;
using System.Security.Claims;

namespace QuanLyBanTuBepWeb.Controllers
{
    public class CartController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;
        private const string CartSessionKey = "KITCHEN_CART_SESSION";

        public CartController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        // Quản lý trạng thái Giỏ hàng trong Session
        private List<CartItem> GetCart()
        {
            return HttpContext.Session.GetObjectFromJson<List<CartItem>>(CartSessionKey) ?? new List<CartItem>();
        }

        private void SaveCart(List<CartItem> cart)
        {
            HttpContext.Session.SetObjectAsJson(CartSessionKey, cart);
        }

        public IActionResult Index()
        {
            var cart = GetCart();
            ViewBag.TotalAmount = cart.Sum(item => item.ThanhTien);
            return View(cart);
        }

        // Các thao tác Thêm / Cập nhật / Xóa giỏ hàng qua AJAX
        [HttpPost]
        public async Task<IActionResult> AddToCart(string id, int quantity = 1)
        {
            var product = await _context.DMHangHoas.FindAsync(id);
            if (product == null)
            {
                return Json(new { success = false, message = "Sản phẩm không tồn tại" });
            }

            if (product.SoLuong <= 0)
            {
                return Json(new { success = false, message = "Sản phẩm này hiện đang tạm hết hàng" });
            }

            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.MaHang == id);

            if (item != null)
            {
                item.SoLuong += quantity;
            }
            else
            {
                cart.Add(new CartItem
                {
                    MaHang = product.MaHang,
                    TenHang = product.TenHang,
                    Anh = product.AnhChinh,
                    DonGiaBan = product.DonGiaBan ?? 0,
                    SoLuong = quantity
                });
            }

            SaveCart(cart);

            int totalCount = cart.Sum(c => c.SoLuong);
            decimal totalMoney = cart.Sum(c => c.ThanhTien);

            return Json(new
            {
                success = true,
                message = "Đã thêm vào giỏ hàng thành công!",
                totalCount = totalCount,
                totalMoney = totalMoney.ToString("N0") + " đ"
            });
        }

        [HttpPost]
        public IActionResult UpdateQuantity(string id, int quantity)
        {
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.MaHang == id);

            if (item != null)
            {
                if (quantity <= 0)
                {
                    cart.Remove(item);
                }
                else
                {
                    item.SoLuong = quantity;
                }
                SaveCart(cart);
            }

            decimal itemTotal = item != null ? item.ThanhTien : 0;
            decimal cartTotal = cart.Sum(c => c.ThanhTien);
            int totalCount = cart.Sum(c => c.SoLuong);

            return Json(new
            {
                success = true,
                itemTotal = itemTotal.ToString("N0") + " đ",
                cartTotal = cartTotal.ToString("N0") + " đ",
                totalCount = totalCount
            });
        }

        [HttpPost]
        public IActionResult RemoveItem(string id)
        {
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.MaHang == id);
            if (item != null)
            {
                cart.Remove(item);
                SaveCart(cart);
            }

            decimal cartTotal = cart.Sum(c => c.ThanhTien);
            int totalCount = cart.Sum(c => c.SoLuong);

            return Json(new
            {
                success = true,
                message = "Đã xóa sản phẩm khỏi giỏ hàng",
                cartTotal = cartTotal.ToString("N0") + " đ",
                totalCount = totalCount
            });
        }

        // Xử lý đặt hàng và lưu Hóa đơn bán xuống CSDL
        public async Task<IActionResult> Checkout()
        {
            var cart = GetCart();
            if (!cart.Any())
            {
                TempData["ErrorMessage"] = "Giỏ hàng của bạn đang trống!";
                return RedirectToAction(nameof(Index));
            }

            var model = new CheckoutViewModel();

            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                var username = User.Identity.Name;
                var account = await _context.TaiKhoans
                    .Include(t => t.KhachHang)
                    .FirstOrDefaultAsync(t => t.TenDangNhap == username);

                if (account != null)
                {
                    model.HoTen = account.HoTen;
                    model.SoDienThoai = account.SoDienThoai ?? "";
                    model.DiaChi = account.DiaChi ?? "";
                }
            }

            ViewBag.Cart = cart;
            ViewBag.TotalAmount = cart.Sum(c => c.ThanhTien);
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutViewModel model)
        {
            var cart = GetCart();
            if (!cart.Any())
            {
                ModelState.AddModelError("", "Giỏ hàng đang trống");
                return RedirectToAction(nameof(Index));
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Cart = cart;
                ViewBag.TotalAmount = cart.Sum(c => c.ThanhTien);
                return View(model);
            }

            string maKhach = "";
            string? username = User.Identity?.IsAuthenticated == true ? User.Identity.Name : null;
            TaiKhoan? account = null;

            if (!string.IsNullOrEmpty(username))
            {
                account = await _context.TaiKhoans.Include(t => t.KhachHang).FirstOrDefaultAsync(t => t.TenDangNhap == username);
            }

            if (account?.MaKhach != null)
            {
                maKhach = account.MaKhach;
            }
            else
            {
                var khachCu = await _context.KhachHangs.FirstOrDefaultAsync(k => k.DienThoai == model.SoDienThoai);
                if (khachCu != null)
                {
                    maKhach = khachCu.MaKhach;
                }
                else
                {
                    int countKh = await _context.KhachHangs.CountAsync() + 1;
                    maKhach = "KH" + countKh.ToString("D2");
                    while (await _context.KhachHangs.AnyAsync(k => k.MaKhach == maKhach))
                    {
                        countKh++;
                        maKhach = "KH" + countKh.ToString("D2");
                    }

                    var khMoi = new KhachHang
                    {
                        MaKhach = maKhach,
                        TenKhach = model.HoTen,
                        DienThoai = model.SoDienThoai,
                        DiaChi = model.DiaChi
                    };
                    _context.KhachHangs.Add(khMoi);

                    if (account != null)
                    {
                        account.MaKhach = maKhach;
                    }
                    await _context.SaveChangesAsync();
                }
            }

            string soHDB = "HDB" + DateTime.Now.ToString("yyMMddHHmmss");
            var nv = await _context.NhanViens.FirstOrDefaultAsync(n => n.MaCV == "CV02") ?? await _context.NhanViens.FirstOrDefaultAsync();

            var hoaDon = new HoaDonBan
            {
                SoHDB = soHDB,
                MaNV = nv?.MaNV,
                NgayBan = DateTime.Now,
                MaKhach = maKhach,
                TongTien = 0
            };
            _context.HoaDonBans.Add(hoaDon);
            await _context.SaveChangesAsync();

            foreach (var item in cart)
            {
                var ct = new ChiTietHoaDonBan
                {
                    SoHDB = soHDB,
                    MaHang = item.MaHang,
                    SoLuong = item.SoLuong,
                    GiamGia = 0,
                    ThanhTien = 0
                };
                _context.ChiTietHoaDonBans.Add(ct);
            }
            await _context.SaveChangesAsync();

            HttpContext.Session.Remove(CartSessionKey);

            return RedirectToAction(nameof(OrderSuccess), new { id = soHDB });
        }

        public async Task<IActionResult> OrderSuccess(string id)
        {
            var order = await _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.ChiTietHoaDonBans)
                    .ThenInclude(ct => ct.DMHangHoa)
                .FirstOrDefaultAsync(h => h.SoHDB == id);

            if (order == null) return RedirectToAction("Index", "Home");

            return View(order);
        }
    }
}
