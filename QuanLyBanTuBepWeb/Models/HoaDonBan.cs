using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("HoaDonBan")]
    public class HoaDonBan
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Số HĐ bán")]
        public string SoHDB { get; set; } = null!;

        [StringLength(20)]
        [Display(Name = "Nhân viên")]
        public string? MaNV { get; set; }

        [Display(Name = "Ngày bán")]
        [DataType(DataType.Date)]
        public DateTime? NgayBan { get; set; } = DateTime.Now;

        [StringLength(20)]
        [Display(Name = "Khách hàng")]
        public string? MaKhach { get; set; }

        [Display(Name = "Tổng tiền")]
        [Column(TypeName = "decimal(18, 2)")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? TongTien { get; set; } = 0;

        [ForeignKey("MaNV")]
        [Display(Name = "Nhân viên")]
        public virtual NhanVien? NhanVien { get; set; }

        [ForeignKey("MaKhach")]
        [Display(Name = "Khách hàng")]
        public virtual KhachHang? KhachHang { get; set; }

        public virtual ICollection<ChiTietHoaDonBan> ChiTietHoaDonBans { get; set; } = new List<ChiTietHoaDonBan>();
    }
}
