using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
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

        // 1. Đăng nhập và cấp phát Cookie Authentication
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model, string? returnUrl)
        {
            if (!ModelState.IsValid) return View(model);

            var user = await _context.TaiKhoans
                .Include(t => t.KhachHang)
                .Include(t => t.NhanVien)
                .FirstOrDefaultAsync(t => t.TenDangNhap == model.TenDangNhap);

            if (user == null)
            {
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không chính xác!");
                return View(model);
            }

            var hasher = new PasswordHasher<TaiKhoan>();
            bool isPasswordValid = false;

            try
            {
                var verifyResult = hasher.VerifyHashedPassword(user, user.MatKhau, model.MatKhau);
                if (verifyResult == PasswordVerificationResult.Success || verifyResult == PasswordVerificationResult.SuccessRehashNeeded)
                {
                    isPasswordValid = true;
                }
            }
            catch
            {
                isPasswordValid = false;
            }

            if (!isPasswordValid && user.MatKhau == model.MatKhau)
            {
                isPasswordValid = true;
                user.MatKhau = hasher.HashPassword(user, model.MatKhau);
                await _context.SaveChangesAsync();
            }

            if (!isPasswordValid)
            {
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không chính xác!");
                return View(model);
            }

            if (!user.TrangThai)
            {
                ModelState.AddModelError("", "Tài khoản của bạn hiện đang bị khóa!");
                return View(model);
            }

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

        // 2. Đăng ký tài khoản Khách hàng mới
        public IActionResult Register()
        {
            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            if (await _context.TaiKhoans.AnyAsync(t => t.TenDangNhap == model.TenDangNhap))
            {
                ModelState.AddModelError("TenDangNhap", "Tên đăng nhập này đã được sử dụng. Vui lòng chọn tên khác!");
                return View(model);
            }

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
                TenKhach = model.HoTen.Trim(),
                DienThoai = model.SoDienThoai.Trim(),
                DiaChi = string.IsNullOrWhiteSpace(model.DiaChi) ? null : model.DiaChi.Trim()
            };
            _context.KhachHangs.Add(khachHang);

            var hasher = new PasswordHasher<TaiKhoan>();
            var taiKhoan = new TaiKhoan
            {
                TenDangNhap = model.TenDangNhap.Trim(),
                MatKhau = hasher.HashPassword(null!, model.MatKhau),
                HoTen = model.HoTen.Trim(),
                Email = string.IsNullOrWhiteSpace(model.Email) ? null : model.Email.Trim(),
                SoDienThoai = model.SoDienThoai.Trim(),
                DiaChi = string.IsNullOrWhiteSpace(model.DiaChi) ? null : model.DiaChi.Trim(),
                Quyen = "KhachHang",
                MaKhach = maKhach,
                TrangThai = true,
                NgayTao = DateTime.Now
            };
            _context.TaiKhoans.Add(taiKhoan);

            await _context.SaveChangesAsync();

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

        // 3. Đăng xuất và lịch sử đơn hàng cá nhân
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            TempData["SuccessMessage"] = "Bạn đã đăng xuất thành công.";
            return RedirectToAction("Index", "Home");
        }

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

        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}
