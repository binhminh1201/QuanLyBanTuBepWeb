using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("MauSac")]
    public class MauSac
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã màu")]
        public string MaMau { get; set; } = null!;

        [Required(ErrorMessage = "Tên màu không được để trống")]
        [StringLength(50)]
        [Display(Name = "Tên màu")]
        public string TenMau { get; set; } = null!;

        public virtual ICollection<DMHangHoa> DMHangHoas { get; set; } = new List<DMHangHoa>();
    }
}
