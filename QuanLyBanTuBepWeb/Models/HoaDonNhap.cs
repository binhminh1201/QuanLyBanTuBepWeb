using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("HoaDonNhap")]
    public class HoaDonNhap
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Số HĐ nhập")]
        public string SoHDN { get; set; } = null!;

        [StringLength(20)]
        [Display(Name = "Nhân viên")]
        public string? MaNV { get; set; }

        [Display(Name = "Ngày nhập")]
        [DataType(DataType.Date)]
        public DateTime? NgayNhap { get; set; } = DateTime.Now;

        [StringLength(20)]
        [Display(Name = "Nhà cung cấp")]
        public string? MaNCC { get; set; }

        [Display(Name = "Tổng tiền")]
        [Column(TypeName = "decimal(18, 2)")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? TongTien { get; set; } = 0;

        [ForeignKey("MaNV")]
        [Display(Name = "Nhân viên")]
        public virtual NhanVien? NhanVien { get; set; }

        [ForeignKey("MaNCC")]
        [Display(Name = "Nhà cung cấp")]
        public virtual NhaCungCap? NhaCungCap { get; set; }

        public virtual ICollection<ChiTietHoaDonNhap> ChiTietHoaDonNhaps { get; set; } = new List<ChiTietHoaDonNhap>();
    }
}
