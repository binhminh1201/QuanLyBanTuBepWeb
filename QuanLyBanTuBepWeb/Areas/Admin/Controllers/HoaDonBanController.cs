using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;

namespace QuanLyBanTuBepWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class HoaDonBanController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;

        public HoaDonBanController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        // GET: Admin/HoaDonBan
        public async Task<IActionResult> Index(DateTime? tuNgay, DateTime? denNgay)
        {
            var query = _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.NhanVien)
                .AsQueryable();

            if (tuNgay.HasValue) query = query.Where(h => h.NgayBan >= tuNgay.Value);
            if (denNgay.HasValue) query = query.Where(h => h.NgayBan <= denNgay.Value);

            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");

            return View(await query.OrderByDescending(h => h.NgayBan).ToListAsync());
        }

        // GET: Admin/HoaDonBan/Details/HDB01
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var invoice = await _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.NhanVien)
                .Include(h => h.ChiTietHoaDonBans)
                    .ThenInclude(ct => ct.DMHangHoa)
                .FirstOrDefaultAsync(h => h.SoHDB == id);

            if (invoice == null) return NotFound();

            return View(invoice);
        }
    }
}
