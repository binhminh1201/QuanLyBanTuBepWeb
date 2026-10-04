namespace QuanLyBanTuBepWeb.Models.ViewModels
{
    public class ProductFilterVM
    {
        public List<DMHangHoa> DanhSachHangHoa { get; set; } = new List<DMHangHoa>();
        public string? Keyword { get; set; }
        public string? MaChatLieu { get; set; }
        public string? MaMau { get; set; }
        public string? MaKichThuoc { get; set; }
        public string? MaNuocSX { get; set; }
        public decimal? GiaTu { get; set; }
        public decimal? GiaDen { get; set; }
        public string? SapXep { get; set; } // "price_asc", "price_desc", "name"

        public int CurrentPage { get; set; } = 1;
        public int TotalPages { get; set; } = 1;
        public int TotalItems { get; set; } = 0;
        public int PageSize { get; set; } = 6;
    }
}
