namespace QuanLyBanTuBepWeb.Models.ViewModels
{
    public class HoaDonNhapTheoNVItemVM
    {
        public string SoHDN { get; set; } = null!;
        public DateTime? NgayNhap { get; set; }
        public string MaNV { get; set; } = null!;
        public string TenNV { get; set; } = null!;
        public string? TenNCC { get; set; }
        public string MaHang { get; set; } = null!;
        public string TenHang { get; set; } = null!;
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
        public double GiamGia { get; set; }
        public decimal ThanhTien { get; set; }
        public decimal TongTienHoaDon { get; set; }
    }
}
