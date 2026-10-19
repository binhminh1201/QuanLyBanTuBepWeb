using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;
using QuanLyBanTuBepWeb.Models.ViewModels;

namespace QuanLyBanTuBepWeb.ViewComponents
{
    public class ProductFilterSidebarViewComponent : ViewComponent
    {
        private readonly QuanLyBanTuBepContext _context;

        public ProductFilterSidebarViewComponent(QuanLyBanTuBepContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync(ProductFilterVM filter)
        {
            var vm = new SidebarFilterVM
            {
                CurrentFilter = filter ?? new ProductFilterVM(),
                ChatLieus = await _context.ChatLieus.OrderBy(c => c.TenChatLieu).ToListAsync(),
                MauSacs = await _context.MauSacs.OrderBy(m => m.TenMau).ToListAsync(),
                KichThuocs = await _context.KichThuocs.OrderBy(k => k.TenKichThuoc).ToListAsync(),
                NuocSanXuats = await _context.NuocSanXuats.OrderBy(n => n.TenNuocSX).ToListAsync()
            };

            return View(vm);
        }
    }
}
