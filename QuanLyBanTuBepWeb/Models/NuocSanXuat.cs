using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("NuocSanXuat")]
    public class NuocSanXuat
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã nước sản xuất")]
        public string MaNuocSX { get; set; } = null!;

        [Required(ErrorMessage = "Tên nước sản xuất không được để trống")]
        [StringLength(50)]
        [Display(Name = "Tên nước sản xuất")]
        public string TenNuocSX { get; set; } = null!;

        public virtual ICollection<DMHangHoa> DMHangHoas { get; set; } = new List<DMHangHoa>();
    }
}
