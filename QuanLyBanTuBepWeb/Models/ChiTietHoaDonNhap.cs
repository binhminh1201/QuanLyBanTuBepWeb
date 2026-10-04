using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("ChiTietHoaDonNhap")]
    public class ChiTietHoaDonNhap
    {
        [Key, Column(Order = 0)]
        [StringLength(20)]
        [Display(Name = "Số HĐ nhập")]
        public string SoHDN { get; set; } = null!;

        [Key, Column(Order = 1)]
        [StringLength(20)]
        [Display(Name = "Mã hàng")]
        public string MaHang { get; set; } = null!;

        [Required]
        [Range(1, 10000, ErrorMessage = "Số lượng nhập phải từ 1 trở lên")]
        [Display(Name = "Số lượng")]
        public int SoLuong { get; set; } = 1;

        [Required]
        [Column(TypeName = "decimal(18, 2)")]
        [Range(0, double.MaxValue, ErrorMessage = "Đơn giá nhập phải lớn hơn hoặc bằng 0")]
        [Display(Name = "Đơn giá nhập")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal DonGia { get; set; }

        [Display(Name = "Giảm giá (%)")]
        [Range(0, 100, ErrorMessage = "Giảm giá từ 0% đến 100%")]
        public double? GiamGia { get; set; } = 0;

        [Display(Name = "Thành tiền")]
        [Column(TypeName = "decimal(18, 2)")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? ThanhTien { get; set; } = 0;

        [ForeignKey("SoHDN")]
        public virtual HoaDonNhap? HoaDonNhap { get; set; }

        [ForeignKey("MaHang")]
        [Display(Name = "Hàng hoá")]
        public virtual DMHangHoa? DMHangHoa { get; set; }
    }
}
