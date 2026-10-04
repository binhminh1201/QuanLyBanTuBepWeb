using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("NhanVien")]
    public class NhanVien
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã nhân viên")]
        public string MaNV { get; set; } = null!;

        [Required(ErrorMessage = "Tên nhân viên không được để trống")]
        [StringLength(100)]
        [Display(Name = "Tên nhân viên")]
        public string TenNV { get; set; } = null!;

        [StringLength(10)]
        [Display(Name = "Giới tính")]
        public string? GioiTinh { get; set; }

        [Display(Name = "Ngày sinh")]
        [DataType(DataType.Date)]
        public DateTime? NgaySinh { get; set; }

        [StringLength(20)]
        [Display(Name = "Điện thoại")]
        public string? DienThoai { get; set; }

        [StringLength(200)]
        [Display(Name = "Địa chỉ")]
        public string? DiaChi { get; set; }

        [StringLength(20)]
        [Display(Name = "Công việc")]
        public string? MaCV { get; set; }

        [ForeignKey("MaCV")]
        [Display(Name = "Công việc")]
        public virtual CongViec? CongViec { get; set; }

        public virtual ICollection<HoaDonBan> HoaDonBans { get; set; } = new List<HoaDonBan>();
        public virtual ICollection<HoaDonNhap> HoaDonNhaps { get; set; } = new List<HoaDonNhap>();
        public virtual ICollection<TaiKhoan> TaiKhoans { get; set; } = new List<TaiKhoan>();
    }
}
