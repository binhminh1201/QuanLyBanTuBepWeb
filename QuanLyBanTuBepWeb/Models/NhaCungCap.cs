using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("NhaCungCap")]
    public class NhaCungCap
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã nhà cung cấp")]
        public string MaNCC { get; set; } = null!;

        [Required(ErrorMessage = "Tên nhà cung cấp không được để trống")]
        [StringLength(150)]
        [Display(Name = "Tên nhà cung cấp")]
        public string TenNCC { get; set; } = null!;

        [StringLength(200)]
        [Display(Name = "Địa chỉ")]
        public string? DiaChi { get; set; }

        [StringLength(20)]
        [Display(Name = "Điện thoại")]
        public string? DienThoai { get; set; }

        public virtual ICollection<HoaDonNhap> HoaDonNhaps { get; set; } = new List<HoaDonNhap>();
    }
}
