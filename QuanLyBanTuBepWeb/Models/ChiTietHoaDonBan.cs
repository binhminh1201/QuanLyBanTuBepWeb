using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("ChiTietHoaDonBan")]
    public class ChiTietHoaDonBan
    {
        [Key, Column(Order = 0)]
        [StringLength(20)]
        [Display(Name = "Số HĐ bán")]
        public string SoHDB { get; set; } = null!;

        [Key, Column(Order = 1)]
        [StringLength(20)]
        [Display(Name = "Mã hàng")]
        public string MaHang { get; set; } = null!;

        [Required]
        [Range(1, 10000, ErrorMessage = "Số lượng bán phải từ 1 trở lên")]
        [Display(Name = "Số lượng")]
        public int SoLuong { get; set; } = 1;

        [Display(Name = "Giảm giá (%)")]
        [Range(0, 100, ErrorMessage = "Giảm giá từ 0% đến 100%")]
        public double? GiamGia { get; set; } = 0;

        [Display(Name = "Thành tiền")]
        [Column(TypeName = "decimal(18, 2)")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? ThanhTien { get; set; } = 0;

        [ForeignKey("SoHDB")]
        public virtual HoaDonBan? HoaDonBan { get; set; }

        [ForeignKey("MaHang")]
        [Display(Name = "Hàng hoá")]
        public virtual DMHangHoa? DMHangHoa { get; set; }
    }
}
