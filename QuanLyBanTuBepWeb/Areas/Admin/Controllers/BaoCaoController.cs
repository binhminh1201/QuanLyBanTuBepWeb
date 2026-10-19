using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;
using QuanLyBanTuBepWeb.Models.ViewModels;

namespace QuanLyBanTuBepWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class BaoCaoController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;

        public BaoCaoController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        // YC 6: Báo cáo danh sách 3 sản phẩm bán được nhiều nhất trong một quý chọn trước
        public async Task<IActionResult> Top3SanPhamTheoQuy(int? nam, int? quy)
        {
            int currentYear = nam ?? DateTime.Now.Year;
            int currentQuarter = quy ?? ((DateTime.Now.Month - 1) / 3 + 1);

            ViewBag.Nam = currentYear;
            ViewBag.Quy = currentQuarter;

            var result = await _context.ChiTietHoaDonBans
                .Include(c => c.HoaDonBan)
                .Include(c => c.DMHangHoa)
                    .ThenInclude(h => h!.ChatLieu)
                .Include(c => c.DMHangHoa)
                    .ThenInclude(h => h!.MauSac)
                .Where(c => c.HoaDonBan != null && c.HoaDonBan.NgayBan.HasValue &&
                            c.HoaDonBan.NgayBan.Value.Year == currentYear &&
                            ((c.HoaDonBan.NgayBan.Value.Month - 1) / 3 + 1) == currentQuarter)
                .GroupBy(c => new
                {
                    c.MaHang,
                    TenHang = c.DMHangHoa != null ? c.DMHangHoa.TenHang : c.MaHang,
                    ChatLieu = c.DMHangHoa != null && c.DMHangHoa.ChatLieu != null ? c.DMHangHoa.ChatLieu.TenChatLieu : "",
                    MauSac = c.DMHangHoa != null && c.DMHangHoa.MauSac != null ? c.DMHangHoa.MauSac.TenMau : ""
                })
                .Select(g => new
                {
                    MaHang = g.Key.MaHang,
                    TenHang = g.Key.TenHang,
                    ChatLieu = g.Key.ChatLieu,
                    MauSac = g.Key.MauSac,
                    TongSoLuong = g.Sum(x => x.SoLuong),
                    TongDoanhThu = g.Sum(x => x.ThanhTien)
                })
                .OrderByDescending(x => x.TongSoLuong)
                .Take(3)
                .ToListAsync();

            return View(result);
        }

        // YC 8: Báo cáo chi tiết danh sách 5 hoá đơn có tổng tiền bán hàng nhỏ nhất theo quý chọn trước
        public async Task<IActionResult> Top5HoaDonNhoNhatTheoQuy(int? nam, int? quy)
        {
            int currentYear = nam ?? DateTime.Now.Year;
            int currentQuarter = quy ?? ((DateTime.Now.Month - 1) / 3 + 1);

            ViewBag.Nam = currentYear;
            ViewBag.Quy = currentQuarter;

            var result = await _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Include(h => h.NhanVien)
                .Where(h => h.NgayBan.HasValue &&
                            h.NgayBan.Value.Year == currentYear &&
                            ((h.NgayBan.Value.Month - 1) / 3 + 1) == currentQuarter)
                .OrderBy(h => h.TongTien)
                .Take(5)
                .ToListAsync();

            return View(result);
        }

        // YC 9: Báo cáo danh sách các khách hàng mua hàng theo tháng chọn trước
        public async Task<IActionResult> KhachHangTheoThang(int? nam, int? thang)
        {
            int currentYear = nam ?? DateTime.Now.Year;
            int currentMonth = thang ?? DateTime.Now.Month;

            ViewBag.Nam = currentYear;
            ViewBag.Thang = currentMonth;

            var result = await _context.HoaDonBans
                .Include(h => h.KhachHang)
                .Where(h => h.NgayBan.HasValue &&
                            h.NgayBan.Value.Year == currentYear &&
                            h.NgayBan.Value.Month == currentMonth &&
                            h.KhachHang != null)
                .GroupBy(h => new
                {
                    h.KhachHang!.MaKhach,
                    h.KhachHang.TenKhach,
                    h.KhachHang.DienThoai,
                    h.KhachHang.DiaChi
                })
                .Select(g => new
                {
                    MaKhach = g.Key.MaKhach,
                    TenKhach = g.Key.TenKhach,
                    DienThoai = g.Key.DienThoai,
                    DiaChi = g.Key.DiaChi,
                    SoDonHang = g.Count(),
                    TongChiTieu = g.Sum(x => x.TongTien)
                })
                .OrderByDescending(x => x.TongChiTieu)
                .ToListAsync();

            return View(result);
        }

        // YC 7: Báo cáo chi tiết danh sách các hoá đơn nhập do một nhân viên nhập được chọn trước
        public async Task<IActionResult> HoaDonNhapTheoNV(string? maNV)
        {
            var nhanViens = await _context.NhanViens.OrderBy(nv => nv.MaNV).ToListAsync();
            ViewBag.NhanViens = nhanViens;

            string selectedNV = !string.IsNullOrEmpty(maNV) 
                ? maNV 
                : (nhanViens.FirstOrDefault(nv => nv.MaNV == "NV04")?.MaNV ?? nhanViens.FirstOrDefault()?.MaNV ?? "");
            ViewBag.SelectedNV = selectedNV;

            var result = await _context.ChiTietHoaDonNhaps
                .Include(ct => ct.HoaDonNhap)
                    .ThenInclude(h => h!.NhanVien)
                .Include(ct => ct.HoaDonNhap)
                    .ThenInclude(h => h!.NhaCungCap)
                .Include(ct => ct.DMHangHoa)
                .Where(ct => ct.HoaDonNhap != null && ct.HoaDonNhap.MaNV == selectedNV)
                .OrderByDescending(ct => ct.HoaDonNhap!.NgayNhap)
                .ThenBy(ct => ct.SoHDN)
                .Select(ct => new HoaDonNhapTheoNVItemVM
                {
                    SoHDN = ct.SoHDN,
                    NgayNhap = ct.HoaDonNhap != null ? ct.HoaDonNhap.NgayNhap : null,
                    MaNV = selectedNV,
                    TenNV = ct.HoaDonNhap != null && ct.HoaDonNhap.NhanVien != null ? ct.HoaDonNhap.NhanVien.TenNV : "",
                    TenNCC = ct.HoaDonNhap != null && ct.HoaDonNhap.NhaCungCap != null ? ct.HoaDonNhap.NhaCungCap.TenNCC : "",
                    MaHang = ct.MaHang,
                    TenHang = ct.DMHangHoa != null ? ct.DMHangHoa.TenHang : ct.MaHang,
                    SoLuong = ct.SoLuong,
                    DonGia = ct.DonGia,
                    GiamGia = ct.GiamGia ?? 0,
                    ThanhTien = ct.ThanhTien ?? 0,
                    TongTienHoaDon = ct.HoaDonNhap != null ? (ct.HoaDonNhap.TongTien ?? 0) : 0
                })
                .ToListAsync();

            return View(result);
        }
    }
}
