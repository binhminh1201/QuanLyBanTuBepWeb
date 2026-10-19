using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Http;

namespace QuanLyBanTuBepWeb.Models
{
    [Table("DMHangHoa")]
    public class DMHangHoa
    {
        [Key]
        [StringLength(20)]
        [Display(Name = "Mã hàng")]
        public string MaHang { get; set; } = null!;

        [Required(ErrorMessage = "Tên hàng hoá không được để trống")]
        [StringLength(150)]
        [Display(Name = "Tên hàng hoá")]
        public string TenHang { get; set; } = null!;

        [StringLength(20)]
        [Display(Name = "Kích thước")]
        public string? MaKichThuoc { get; set; }

        [StringLength(20)]
        [Display(Name = "Chất liệu")]
        public string? MaChatLieu { get; set; }

        [StringLength(20)]
        [Display(Name = "Màu sắc")]
        public string? MaMau { get; set; }

        [StringLength(20)]
        [Display(Name = "Nước sản xuất")]
        public string? MaNuocSX { get; set; }

        [Display(Name = "Số lượng tồn")]
        [Range(0, 100000, ErrorMessage = "Số lượng phải lớn hơn hoặc bằng 0")]
        public int? SoLuong { get; set; } = 0;

        [Display(Name = "Giá nhập")]
        [Column(TypeName = "decimal(18, 2)")]
        [Range(0, double.MaxValue, ErrorMessage = "Giá nhập phải lớn hơn hoặc bằng 0")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? GiaNhap { get; set; } = 0;

        [Display(Name = "Đơn giá bán")]
        [Column(TypeName = "decimal(18, 2)")]
        [Range(0, double.MaxValue, ErrorMessage = "Đơn giá bán phải lớn hơn hoặc bằng 0")]
        [DisplayFormat(DataFormatString = "{0:N0} đ")]
        public decimal? DonGiaBan { get; set; } = 0;

        [StringLength(50)]
        [Display(Name = "Thời gian bảo hành")]
        public string? ThoiGianBaoHanh { get; set; }

        [StringLength(255)]
        [Display(Name = "Hình ảnh")]
        public string? Anh { get; set; }

        [NotMapped]
        public string AnhChinh
        {
            get
            {
                if (string.IsNullOrEmpty(Anh)) return "no_image.png";
                var first = Anh.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();
                return string.IsNullOrEmpty(first) ? "no_image.png" : first.Trim();
            }
        }

        [NotMapped]
        public List<string> DanhSachAnh
        {
            get
            {
                var list = new List<string>();
                if (!string.IsNullOrEmpty(Anh))
                {
                    var parts = Anh.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var p in parts)
                    {
                        var clean = p.Trim();
                        if (!string.IsNullOrEmpty(clean) && !list.Contains(clean))
                            list.Add(clean);
                    }
                }

                if (list.Count > 0)
                {
                    var first = list[0];
                    if (first.EndsWith(".jpg", StringComparison.OrdinalIgnoreCase))
                    {
                        var baseName = first.Substring(0, first.Length - 4);
                        if (!baseName.EndsWith("_angle") && !baseName.EndsWith("_detail") && !baseName.EndsWith("_inside"))
                        {
                            var angleImg = $"{baseName}_angle.jpg";
                            var detailImg = $"{baseName}_detail.jpg";
                            var insideImg = $"{baseName}_inside.jpg";

                            if (!list.Contains(angleImg)) list.Add(angleImg);
                            if (!list.Contains(detailImg)) list.Add(detailImg);
                            if (!list.Contains(insideImg)) list.Add(insideImg);
                        }
                    }
                }

                if (list.Count == 0)
                {
                    list.Add("no_image.png");
                }
                return list;
            }
        }

        [StringLength(500)]
        [Display(Name = "Ghi chú")]
        public string? GhiChu { get; set; }

        // Field upload ảnh không lưu trong DB (Xử lý Controller)
        [NotMapped]
        [Display(Name = "Chọn tệp ảnh")]
        public IFormFile? UploadAnh { get; set; }

        // Navigation Properties
        [ForeignKey("MaKichThuoc")]
        [Display(Name = "Kích thước")]
        public virtual KichThuoc? KichThuoc { get; set; }

        [ForeignKey("MaChatLieu")]
        [Display(Name = "Chất liệu")]
        public virtual ChatLieu? ChatLieu { get; set; }

        [ForeignKey("MaMau")]
        [Display(Name = "Màu sắc")]
        public virtual MauSac? MauSac { get; set; }

        [ForeignKey("MaNuocSX")]
        [Display(Name = "Nước sản xuất")]
        public virtual NuocSanXuat? NuocSanXuat { get; set; }

        public virtual ICollection<ChiTietHoaDonBan> ChiTietHoaDonBans { get; set; } = new List<ChiTietHoaDonBan>();
        public virtual ICollection<ChiTietHoaDonNhap> ChiTietHoaDonNhaps { get; set; } = new List<ChiTietHoaDonNhap>();
    }
}
