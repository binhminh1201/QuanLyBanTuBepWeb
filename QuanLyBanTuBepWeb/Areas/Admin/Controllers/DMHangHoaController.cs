using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;

namespace QuanLyBanTuBepWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class DMHangHoaController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;
        private readonly IWebHostEnvironment _env;

        public DMHangHoaController(QuanLyBanTuBepContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        // GET: Admin/DMHangHoa
        public async Task<IActionResult> Index(string? keyword, string? maChatLieu)
        {
            var query = _context.DMHangHoas
                .Include(p => p.ChatLieu)
                .Include(p => p.MauSac)
                .Include(p => p.KichThuoc)
                .Include(p => p.NuocSanXuat)
                .AsQueryable();

            if (!string.IsNullOrEmpty(keyword))
            {
                var kw = keyword.ToLower();
                query = query.Where(p => p.TenHang.ToLower().Contains(kw) || p.MaHang.ToLower().Contains(kw));
            }

            if (!string.IsNullOrEmpty(maChatLieu))
            {
                query = query.Where(p => p.MaChatLieu == maChatLieu);
            }

            ViewBag.ChatLieus = new SelectList(await _context.ChatLieus.ToListAsync(), "MaChatLieu", "TenChatLieu", maChatLieu);
            ViewBag.Keyword = keyword;

            return View(await query.ToListAsync());
        }

        // GET: Admin/DMHangHoa/Create
        public async Task<IActionResult> Create()
        {
            await PopulateDropdownsAsync();
            return View();
        }

        // POST: Admin/DMHangHoa/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DMHangHoa model)
        {
            if (await _context.DMHangHoas.AnyAsync(h => h.MaHang == model.MaHang))
            {
                ModelState.AddModelError("MaHang", "Mã hàng hoá này đã tồn tại trong hệ thống");
            }

            if (ModelState.IsValid)
            {
                // Xử lý upload ảnh (nếu có chọn file)
                if (model.UploadAnh != null && model.UploadAnh.Length > 0)
                {
                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(model.UploadAnh.FileName);
                    string uploadFolder = Path.Combine(_env.WebRootPath, "images", "products");
                    if (!Directory.Exists(uploadFolder)) Directory.CreateDirectory(uploadFolder);

                    string filePath = Path.Combine(uploadFolder, fileName);
                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await model.UploadAnh.CopyToAsync(stream);
                    }
                    model.Anh = fileName;
                }
                else
                {
                    model.Anh = "no_image.png";
                }

                _context.DMHangHoas.Add(model);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Thêm mới sản phẩm tủ bếp thành công!";
                return RedirectToAction(nameof(Index));
            }

            await PopulateDropdownsAsync(model);
            return View(model);
        }

        // GET: Admin/DMHangHoa/Edit/TB01
        public async Task<IActionResult> Edit(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var product = await _context.DMHangHoas.FindAsync(id);
            if (product == null) return NotFound();

            await PopulateDropdownsAsync(product);
            return View(product);
        }

        // POST: Admin/DMHangHoa/Edit/TB01
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, DMHangHoa model)
        {
            if (id != model.MaHang) return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    var existing = await _context.DMHangHoas.FindAsync(id);
                    if (existing == null) return NotFound();

                    existing.TenHang = model.TenHang;
                    existing.MaKichThuoc = model.MaKichThuoc;
                    existing.MaChatLieu = model.MaChatLieu;
                    existing.MaMau = model.MaMau;
                    existing.MaNuocSX = model.MaNuocSX;
                    existing.SoLuong = model.SoLuong;
                    existing.GiaNhap = model.GiaNhap;
                    existing.DonGiaBan = model.DonGiaBan;
                    existing.ThoiGianBaoHanh = model.ThoiGianBaoHanh;
                    existing.GhiChu = model.GhiChu;

                    // Nếu có upload ảnh mới
                    if (model.UploadAnh != null && model.UploadAnh.Length > 0)
                    {
                        string fileName = Guid.NewGuid().ToString() + Path.GetExtension(model.UploadAnh.FileName);
                        string uploadFolder = Path.Combine(_env.WebRootPath, "images", "products");
                        string filePath = Path.Combine(uploadFolder, fileName);
                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await model.UploadAnh.CopyToAsync(stream);
                        }
                        existing.Anh = fileName;
                    }

                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = "Cập nhật thông tin tủ bếp thành công!";
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!await _context.DMHangHoas.AnyAsync(e => e.MaHang == model.MaHang))
                        return NotFound();
                    else
                        throw;
                }
            }

            await PopulateDropdownsAsync(model);
            return View(model);
        }

        // GET: Admin/DMHangHoa/Details/TB01
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var product = await _context.DMHangHoas
                .Include(p => p.ChatLieu)
                .Include(p => p.MauSac)
                .Include(p => p.KichThuoc)
                .Include(p => p.NuocSanXuat)
                .FirstOrDefaultAsync(p => p.MaHang == id);

            if (product == null) return NotFound();

            return View(product);
        }

        // POST: Admin/DMHangHoa/Delete/TB01
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            var product = await _context.DMHangHoas
                .Include(p => p.ChiTietHoaDonBans)
                .Include(p => p.ChiTietHoaDonNhaps)
                .FirstOrDefaultAsync(p => p.MaHang == id);

            if (product == null)
            {
                TempData["ErrorMessage"] = "Sản phẩm không tồn tại!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra ràng buộc khóa ngoại (Chương 8)
            if (product.ChiTietHoaDonBans.Any() || product.ChiTietHoaDonNhaps.Any())
            {
                TempData["ErrorMessage"] = $"Không thể xoá sản phẩm '{product.TenHang}' vì đã có trong hoá đơn bán hoặc hoá đơn nhập!";
                return RedirectToAction(nameof(Index));
            }

            _context.DMHangHoas.Remove(product);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Đã xoá sản phẩm tủ bếp thành công!";
            return RedirectToAction(nameof(Index));
        }

        private async Task PopulateDropdownsAsync(DMHangHoa? selected = null)
        {
            ViewBag.MaKichThuoc = new SelectList(await _context.KichThuocs.ToListAsync(), "MaKichThuoc", "TenKichThuoc", selected?.MaKichThuoc);
            ViewBag.MaChatLieu = new SelectList(await _context.ChatLieus.ToListAsync(), "MaChatLieu", "TenChatLieu", selected?.MaChatLieu);
            ViewBag.MaMau = new SelectList(await _context.MauSacs.ToListAsync(), "MaMau", "TenMau", selected?.MaMau);
            ViewBag.MaNuocSX = new SelectList(await _context.NuocSanXuats.ToListAsync(), "MaNuocSX", "TenNuocSX", selected?.MaNuocSX);
        }
    }
}
