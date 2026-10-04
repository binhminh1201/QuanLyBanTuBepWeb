using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("KichThuoc")]
    public class KichThuoc
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã kích thước")]
        public string MaKichThuoc { get; set; } = null!;

        [Required(ErrorMessage = "Tên kích thước không được để trống")]
        [StringLength(50)]
        [Display(Name = "Tên kích thước")]
        public string TenKichThuoc { get; set; } = null!;

        public virtual ICollection<DMHangHoa> DMHangHoas { get; set; } = new List<DMHangHoa>();
    }
}
