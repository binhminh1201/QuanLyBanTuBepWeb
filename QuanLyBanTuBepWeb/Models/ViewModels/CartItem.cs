namespace QuanLyBanTuBepWeb.Models.ViewModels
{
    public class CartItem
    {
        public string MaHang { get; set; } = null!;
        public string TenHang { get; set; } = null!;
        public string? Anh { get; set; }
        public decimal DonGiaBan { get; set; }
        public int SoLuong { get; set; } = 1;
        public decimal ThanhTien => DonGiaBan * SoLuong;
    }
}
