using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("ChatLieu")]
    public class ChatLieu
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã chất liệu")]
        public string MaChatLieu { get; set; } = null!;

        [Required(ErrorMessage = "Tên chất liệu không được để trống")]
        [StringLength(50)]
        [Display(Name = "Tên chất liệu")]
        public string TenChatLieu { get; set; } = null!;

        public virtual ICollection<DMHangHoa> DMHangHoas { get; set; } = new List<DMHangHoa>();
    }
}
