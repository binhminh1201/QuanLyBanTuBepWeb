using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;

namespace QuanLyBanTuBepWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class HomeController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;

        public HomeController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            // Các số liệu thống kê tổng quan
            ViewBag.TongDoanhThu = await _context.HoaDonBans.SumAsync(h => (decimal?)h.TongTien) ?? 0;
            ViewBag.TongSoDonHang = await _context.HoaDonBans.CountAsync();
            ViewBag.TongSanPham = await _context.DMHangHoas.CountAsync();
            ViewBag.TongTonKho = await _context.DMHangHoas.SumAsync(h => (int?)h.SoLuong) ?? 0;
            ViewBag.TongKhachHang = await _context.KhachHangs.CountAsync();

            // Đơn hàng bán gần đây
            ViewBag.DonHangMoi = await _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.NhanVien)
                .OrderByDescending(h => h.NgayBan)
                .Take(5)
                .ToListAsync();

            // Sản phẩm sắp hết hàng (tồn kho <= 3)
            ViewBag.SapHetHang = await _context.DMHangHoas
                .Where(p => p.SoLuong <= 3)
                .OrderBy(p => p.SoLuong)
                .Take(5)
                .ToListAsync();

            return View();
        }
    }
}
