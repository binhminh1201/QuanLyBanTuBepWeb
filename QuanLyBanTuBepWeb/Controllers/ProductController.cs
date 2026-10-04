using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;
using QuanLyBanTuBepWeb.Models.ViewModels;

namespace QuanLyBanTuBepWeb.Controllers
{
    public class ProductController : Controller
    {
        private readonly QuanLyBanTuBepContext _context;
        private const int PageSize = 6;

        public ProductController(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        // GET: /Product
        public async Task<IActionResult> Index(string? keyword, string? maChatLieu, string? maMau, string? maKichThuoc, string? maNuocSX, decimal? giaTu, decimal? giaDen, string? sapXep, int page = 1)
        {
            // Nạp dữ liệu các bộ lọc cho Sidebar
            ViewBag.ChatLieus = await _context.ChatLieus.ToListAsync();
            ViewBag.MauSacs = await _context.MauSacs.ToListAsync();
            ViewBag.KichThuocs = await _context.KichThuocs.ToListAsync();
            ViewBag.NuocSanXuats = await _context.NuocSanXuats.ToListAsync();

            var vm = await QueryProductsAsync(keyword, maChatLieu, maMau, maKichThuoc, maNuocSX, giaTu, giaDen, sapXep, page);
            return View(vm);
        }

        // GET: /Product/FilterProducts (Phục vụ AJAX theo chuẩn Lab 5 & Lab 6)
        [HttpGet]
        public async Task<IActionResult> FilterProducts(string? keyword, string? maChatLieu, string? maMau, string? maKichThuoc, string? maNuocSX, decimal? giaTu, decimal? giaDen, string? sapXep, int page = 1)
        {
            var vm = await QueryProductsAsync(keyword, maChatLieu, maMau, maKichThuoc, maNuocSX, giaTu, giaDen, sapXep, page);
            return PartialView("_ProductListPartial", vm);
        }

        // GET: /Product/Details/TB01
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

            // Lấy sản phẩm tương tự cùng chất liệu
            ViewBag.RelatedProducts = await _context.DMHangHoas
                .Where(p => p.MaChatLieu == product.MaChatLieu && p.MaHang != product.MaHang)
                .Take(4)
                .ToListAsync();

            return View(product);
        }

        // Hàm truy vấn tổng hợp dùng chung cho cả View ban đầu và AJAX
        private async Task<ProductFilterVM> QueryProductsAsync(string? keyword, string? maChatLieu, string? maMau, string? maKichThuoc, string? maNuocSX, decimal? giaTu, decimal? giaDen, string? sapXep, int page)
        {
            var query = _context.DMHangHoas
                .Include(p => p.ChatLieu)
                .Include(p => p.MauSac)
                .Include(p => p.KichThuoc)
                .Include(p => p.NuocSanXuat)
                .AsQueryable();

            // 1. Lọc theo từ khóa tìm kiếm
            if (!string.IsNullOrWhiteSpace(keyword))
            {
                var kw = keyword.Trim().ToLower();
                query = query.Where(p => p.TenHang.ToLower().Contains(kw) || p.MaHang.ToLower().Contains(kw));
            }

            // 2. Lọc theo thuộc tính
            if (!string.IsNullOrEmpty(maChatLieu)) query = query.Where(p => p.MaChatLieu == maChatLieu);
            if (!string.IsNullOrEmpty(maMau)) query = query.Where(p => p.MaMau == maMau);
            if (!string.IsNullOrEmpty(maKichThuoc)) query = query.Where(p => p.MaKichThuoc == maKichThuoc);
            if (!string.IsNullOrEmpty(maNuocSX)) query = query.Where(p => p.MaNuocSX == maNuocSX);

            // 3. Lọc theo khoảng giá
            if (giaTu.HasValue && giaTu > 0) query = query.Where(p => p.DonGiaBan >= giaTu.Value);
            if (giaDen.HasValue && giaDen > 0) query = query.Where(p => p.DonGiaBan <= giaDen.Value);

            // 4. Sắp xếp
            query = sapXep switch
            {
                "price_asc" => query.OrderBy(p => p.DonGiaBan),
                "price_desc" => query.OrderByDescending(p => p.DonGiaBan),
                "name_asc" => query.OrderBy(p => p.TenHang),
                _ => query.OrderByDescending(p => p.MaHang)
            };

            // 5. Phân trang
            int totalItems = await query.CountAsync();
            int totalPages = (int)Math.Ceiling(totalItems / (double)PageSize);
            if (totalPages < 1) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            var items = await query.Skip((page - 1) * PageSize).Take(PageSize).ToListAsync();

            return new ProductFilterVM
            {
                DanhSachHangHoa = items,
                Keyword = keyword,
                MaChatLieu = maChatLieu,
                MaMau = maMau,
                MaKichThuoc = maKichThuoc,
                MaNuocSX = maNuocSX,
                GiaTu = giaTu,
                GiaDen = giaDen,
                SapXep = sapXep,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = totalItems,
                PageSize = PageSize
            };
        }
    }
}
