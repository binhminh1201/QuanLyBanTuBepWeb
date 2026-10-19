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
        // YC 5: Tìm kiếm các HĐ bán theo: mã hàng, ngày bán, tổng tiền
        public async Task<IActionResult> Index(string? maHang, DateTime? ngayBan, DateTime? tuNgay, DateTime? denNgay, decimal? tongTienTu, decimal? tongTienDen)
        {
            var query = _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.NhanVien)
                .Include(h => h.ChiTietHoaDonBans)
                .AsQueryable();

            if (!string.IsNullOrEmpty(maHang))
            {
                query = query.Where(h => h.ChiTietHoaDonBans.Any(ct => ct.MaHang == maHang));
            }

            if (ngayBan.HasValue)
            {
                query = query.Where(h => h.NgayBan == ngayBan.Value.Date);
            }
            else
            {
                if (tuNgay.HasValue) query = query.Where(h => h.NgayBan >= tuNgay.Value.Date);
                if (denNgay.HasValue) query = query.Where(h => h.NgayBan <= denNgay.Value.Date);
            }

            if (tongTienTu.HasValue && tongTienTu > 0)
            {
                query = query.Where(h => h.TongTien >= tongTienTu.Value);
            }

            if (tongTienDen.HasValue && tongTienDen > 0)
            {
                query = query.Where(h => h.TongTien <= tongTienDen.Value);
            }

            ViewBag.HangHoas = await _context.DMHangHoas.OrderBy(h => h.MaHang).ToListAsync();
            ViewBag.MaHang = maHang;
            ViewBag.NgayBan = ngayBan?.ToString("yyyy-MM-dd");
            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");
            ViewBag.TongTienTu = tongTienTu;
            ViewBag.TongTienDen = tongTienDen;

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
