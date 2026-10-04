using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;
using QuanLyBanTuBepWeb.Models.ViewModels;
using System.Security.Claims;

namespace QuanLyBanTuBepWeb.Controllers
{
    public class AccountController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;

        public AccountController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        // GET: /Account/Login
        public IActionResult Login(string? returnUrl)
        {
            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                if (User.IsInRole("Admin")) return RedirectToAction("Index", "Home", new { area = "Admin" });
                return RedirectToAction("Index", "Home");
            }

            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string? returnUrl)
        {
            if (!ModelState.IsValid) return View(model);

            var user = await _context.TaiKhoans
                .Include(t => t.KhachHang)
                .Include(t => t.NhanVien)
                .FirstOrDefaultAsync(t => t.TenDangNhap == model.TenDangNhap && t.MatKhau == model.MatKhau);

            if (user == null)
            {
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không chính xác!");
                return View(model);
            }

            if (!user.TrangThai)
            {
                ModelState.AddModelError("", "Tài khoản của bạn hiện đang bị khóa!");
                return View(model);
            }

            // Tạo Claims danh tính người dùng
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.TenDangNhap),
                new Claim(ClaimTypes.GivenName, user.HoTen),
                new Claim(ClaimTypes.Role, user.Quyen),
                new Claim("Email", user.Email ?? ""),
                new Claim("Phone", user.SoDienThoai ?? "")
            };

            if (!string.IsNullOrEmpty(user.MaKhach)) claims.Add(new Claim("MaKhach", user.MaKhach));
            if (!string.IsNullOrEmpty(user.MaNV)) claims.Add(new Claim("MaNV", user.MaNV));

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            var authProperties = new AuthenticationProperties
            {
                IsPersistent = model.GhiNho,
                ExpiresUtc = model.GhiNho ? DateTimeOffset.UtcNow.AddDays(7) : DateTimeOffset.UtcNow.AddHours(2)
            };

            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal, authProperties);

            TempData["SuccessMessage"] = $"Xin chào, {user.HoTen}!";

            // Phân quyền điều hướng
            if (user.Quyen == "Admin")
            {
                return RedirectToAction("Index", "Home", new { area = "Admin" });
            }

            if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }

            return RedirectToAction("Index", "Home");
        }

        // GET: /Account/Register
        public IActionResult Register()
        {
            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }

        // POST: /Account/Register
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            // Kiểm tra trùng tên đăng nhập
            if (await _context.TaiKhoans.AnyAsync(t => t.TenDangNhap == model.TenDangNhap))
            {
                ModelState.AddModelError("TenDangNhap", "Tên đăng nhập này đã được sử dụng. Vui lòng chọn tên khác!");
                return View(model);
            }

            // Tạo mã khách hàng mới
            int countKh = await _context.KhachHangs.CountAsync() + 1;
            string maKhach = "KH" + countKh.ToString("D2");
            while (await _context.KhachHangs.AnyAsync(k => k.MaKhach == maKhach))
            {
                countKh++;
                maKhach = "KH" + countKh.ToString("D2");
            }

            var khachHang = new KhachHang
            {
                MaKhach = maKhach,
                TenKhach = model.HoTen,
                DienThoai = model.SoDienThoai,
                DiaChi = model.DiaChi
            };
            _context.KhachHangs.Add(khachHang);

            var taiKhoan = new TaiKhoan
            {
                TenDangNhap = model.TenDangNhap,
                MatKhau = model.MatKhau,
                HoTen = model.HoTen,
                Email = model.Email,
                SoDienThoai = model.SoDienThoai,
                DiaChi = model.DiaChi,
                Quyen = "KhachHang",
                MaKhach = maKhach,
                TrangThai = true,
                NgayTao = DateTime.Now
            };
            _context.TaiKhoans.Add(taiKhoan);

            await _context.SaveChangesAsync();

            // Tự động đăng nhập sau khi đăng ký
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, taiKhoan.TenDangNhap),
                new Claim(ClaimTypes.GivenName, taiKhoan.HoTen),
                new Claim(ClaimTypes.Role, taiKhoan.Quyen),
                new Claim("MaKhach", maKhach)
            };
            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(identity));

            TempData["SuccessMessage"] = "Đăng ký tài khoản thành công!";
            return RedirectToAction("Index", "Home");
        }

        // GET: /Account/Logout
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            TempData["SuccessMessage"] = "Bạn đã đăng xuất thành công.";
            return RedirectToAction("Index", "Home");
        }

        // GET: /Account/Orders (Lịch sử đơn hàng cá nhân)
        [Authorize]
        public async Task<IActionResult> Orders()
        {
            var username = User.Identity?.Name;
            var account = await _context.TaiKhoans.FirstOrDefaultAsync(t => t.TenDangNhap == username);
            if (account == null || string.IsNullOrEmpty(account.MaKhach))
            {
                return RedirectToAction("Index", "Home");
            }

            var orders = await _context.HoaDonBans
                .Where(h => h.MaKhach == account.MaKhach)
                .Include(h => h.ChiTietHoaDonBans)
                    .ThenInclude(ct => ct.DMHangHoa)
                .OrderByDescending(h => h.NgayBan)
                .ToListAsync();

            return View(orders);
        }

        // GET: /Account/AccessDenied
        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}
