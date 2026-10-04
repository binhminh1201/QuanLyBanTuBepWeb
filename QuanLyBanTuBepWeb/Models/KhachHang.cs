using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("KhachHang")]
    public class KhachHang
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã khách hàng")]
        public string MaKhach { get; set; } = null!;

        [Required(ErrorMessage = "Họ tên khách hàng không được để trống")]
        [StringLength(100)]
        [Display(Name = "Tên khách hàng")]
        public string TenKhach { get; set; } = null!;

        [StringLength(200)]
        [Display(Name = "Địa chỉ")]
        public string? DiaChi { get; set; }

        [StringLength(20)]
        [Display(Name = "Điện thoại")]
        [RegularExpression(@"^0\d{9,10}$", ErrorMessage = "Số điện thoại không đúng định dạng (bắt đầu bằng số 0, gồm 10-11 chữ số)")]
        public string? DienThoai { get; set; }

        public virtual ICollection<HoaDonBan> HoaDonBans { get; set; } = new List<HoaDonBan>();
        public virtual ICollection<TaiKhoan> TaiKhoans { get; set; } = new List<TaiKhoan>();
    }
}
