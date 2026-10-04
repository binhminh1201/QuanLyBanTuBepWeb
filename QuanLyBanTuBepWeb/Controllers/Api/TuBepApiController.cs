using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;

namespace QuanLyBanTuBepWeb.Controllers.Api
{
    [ApiController]
    [Route("api/tubep")]
    [Produces("application/json")]
    public class TuBepApiController : ControllerBase
    {
        private readonly QuanLyBanTuBepContext _context;

        public TuBepApiController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        // GET: /api/tubep
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string? keyword, [FromQuery] string? maChatLieu)
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

            var list = await query.Select(p => new
            {
                maHang = p.MaHang,
                tenHang = p.TenHang,
                chatLieu = p.ChatLieu != null ? p.ChatLieu.TenChatLieu : "",
                mauSac = p.MauSac != null ? p.MauSac.TenMau : "",
                kichThuoc = p.KichThuoc != null ? p.KichThuoc.TenKichThuoc : "",
                nuocSX = p.NuocSanXuat != null ? p.NuocSanXuat.TenNuocSX : "",
                soLuong = p.SoLuong,
                giaBan = p.DonGiaBan,
                thoiGianBaoHanh = p.ThoiGianBaoHanh,
                hinhAnh = p.Anh
            }).ToListAsync();

            return Ok(new { total = list.Count, data = list });
        }

        // GET: /api/tubep/TB01
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var product = await _context.DMHangHoas
                .Include(p => p.ChatLieu)
                .Include(p => p.MauSac)
                .Include(p => p.KichThuoc)
                .Include(p => p.NuocSanXuat)
                .FirstOrDefaultAsync(p => p.MaHang == id);

            if (product == null)
            {
                return NotFound(new { message = "Không tìm thấy sản phẩm có mã " + id });
            }

            return Ok(new
            {
                maHang = product.MaHang,
                tenHang = product.TenHang,
                chatLieu = product.ChatLieu?.TenChatLieu,
                mauSac = product.MauSac?.TenMau,
                kichThuoc = product.KichThuoc?.TenKichThuoc,
                nuocSX = product.NuocSanXuat?.TenNuocSX,
                soLuong = product.SoLuong,
                giaBan = product.DonGiaBan,
                thoiGianBaoHanh = product.ThoiGianBaoHanh,
                hinhAnh = product.Anh,
                ghiChu = product.GhiChu
            });
        }
    }
}
