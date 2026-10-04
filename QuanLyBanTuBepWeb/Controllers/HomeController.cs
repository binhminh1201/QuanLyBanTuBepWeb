using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;
using System.Diagnostics;

namespace QuanLyBanTuBepWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;

        public HomeController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            // Lấy 6 sản phẩm tủ bếp mới nhất hiển thị trang chủ
            var products = await _context.DMHangHoas
                .Include(p => p.ChatLieu)
                .Include(p => p.MauSac)
                .Include(p => p.KichThuoc)
                .Include(p => p.NuocSanXuat)
                .OrderByDescending(p => p.MaHang)
                .Take(6)
                .ToListAsync();

            ViewBag.ChatLieus = await _context.ChatLieus.ToListAsync();
            ViewBag.MauSacs = await _context.MauSacs.ToListAsync();

            return View(products);
        }

        public IActionResult About()
        {
            return View();
        }

        public IActionResult Contact()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
