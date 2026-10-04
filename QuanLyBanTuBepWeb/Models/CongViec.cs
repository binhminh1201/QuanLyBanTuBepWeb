using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("CongViec")]
    public class CongViec
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã công việc")]
        public string MaCV { get; set; } = null!;

        [Required(ErrorMessage = "Tên công việc không được để trống")]
        [StringLength(100)]
        [Display(Name = "Tên công việc")]
        public string TenCV { get; set; } = null!;

        [Display(Name = "Mức lương")]
        [Column(TypeName = "decimal(18, 0)")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? MucLuong { get; set; }

        public virtual ICollection<NhanVien> NhanViens { get; set; } = new List<NhanVien>();
    }
}
