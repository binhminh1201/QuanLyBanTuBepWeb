using Microsoft.EntityFrameworkCore;

namespace QuanLyBanTuBepWeb.Models
{
    public class QuanLyBanTuBepContext : DbContext
    {
        public QuanLyBanTuBepContext(DbContextOptions<QuanLyBanTuBepContext> options)
            : base(options)
        {
        }

        public virtual DbSet<KichThuoc> KichThuocs { get; set; } = null!;
        public virtual DbSet<ChatLieu> ChatLieus { get; set; } = null!;
        public virtual DbSet<NuocSanXuat> NuocSanXuats { get; set; } = null!;
        public virtual DbSet<MauSac> MauSacs { get; set; } = null!;
        public virtual DbSet<CongViec> CongViecs { get; set; } = null!;
        public virtual DbSet<KhachHang> KhachHangs { get; set; } = null!;
        public virtual DbSet<NhaCungCap> NhaCungCaps { get; set; } = null!;
        public virtual DbSet<NhanVien> NhanViens { get; set; } = null!;
        public virtual DbSet<DMHangHoa> DMHangHoas { get; set; } = null!;
        public virtual DbSet<HoaDonBan> HoaDonBans { get; set; } = null!;
        public virtual DbSet<ChiTietHoaDonBan> ChiTietHoaDonBans { get; set; } = null!;
        public virtual DbSet<HoaDonNhap> HoaDonNhaps { get; set; } = null!;
        public virtual DbSet<ChiTietHoaDonNhap> ChiTietHoaDonNhaps { get; set; } = null!;
        public virtual DbSet<TaiKhoan> TaiKhoans { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Composite Key for ChiTietHoaDonBan
            modelBuilder.Entity<ChiTietHoaDonBan>()
                .HasKey(c => new { c.SoHDB, c.MaHang });

            // Composite Key for ChiTietHoaDonNhap
            modelBuilder.Entity<ChiTietHoaDonNhap>()
                .HasKey(c => new { c.SoHDN, c.MaHang });

            // Decimal precision mappings
            modelBuilder.Entity<CongViec>()
                .Property(c => c.MucLuong)
                .HasColumnType("decimal(18, 0)");

            modelBuilder.Entity<DMHangHoa>()
                .Property(d => d.GiaNhap)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<DMHangHoa>()
                .Property(d => d.DonGiaBan)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<HoaDonBan>()
                .Property(h => h.TongTien)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<ChiTietHoaDonBan>()
                .Property(c => c.ThanhTien)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<HoaDonNhap>()
                .Property(h => h.TongTien)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<ChiTietHoaDonNhap>()
                .Property(c => c.DonGia)
                .HasColumnType("decimal(18, 2)");

            modelBuilder.Entity<ChiTietHoaDonNhap>()
                .Property(c => c.ThanhTien)
                .HasColumnType("decimal(18, 2)");
        }
    }
}
