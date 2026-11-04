-- ==========================================================================================
-- BÀI TẬP LỚN: LẬP TRÌNH TRỰC QUAN - NHÓM 5
-- ĐỀ TÀI: QUẢN LÝ BÁN TỦ BẾP
-- File nguồn: 47_Quan_ly_ban_tu_bep.xlsx
-- Hệ quản trị CSDL: Microsoft SQL Server 2022 (hoặc 2014, 2016, 2019+)
-- ==========================================================================================

-- 1. TẠO CƠ SỞ DỮ LIỆU
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanLyBanTuBep')
BEGIN
    CREATE DATABASE QuanLyBanTuBep;
END
GO

USE QuanLyBanTuBep;
GO

-- 2. XÓA CÁC BẢNG CŨ NẾU ĐÃ TỒN TẠI (Đảm bảo chạy lại script không lỗi)
IF OBJECT_ID(N'TaiKhoan', N'U') IS NOT NULL DROP TABLE TaiKhoan;
IF OBJECT_ID(N'ChiTietHoaDonBan', N'U') IS NOT NULL DROP TABLE ChiTietHoaDonBan;
IF OBJECT_ID(N'ChiTietHoaDonNhap', N'U') IS NOT NULL DROP TABLE ChiTietHoaDonNhap;
IF OBJECT_ID(N'HoaDonBan', N'U') IS NOT NULL DROP TABLE HoaDonBan;
IF OBJECT_ID(N'HoaDonNhap', N'U') IS NOT NULL DROP TABLE HoaDonNhap;
IF OBJECT_ID(N'DMHangHoa', N'U') IS NOT NULL DROP TABLE DMHangHoa;
IF OBJECT_ID(N'NhanVien', N'U') IS NOT NULL DROP TABLE NhanVien;
IF OBJECT_ID(N'CongViec', N'U') IS NOT NULL DROP TABLE CongViec;
IF OBJECT_ID(N'KhachHang', N'U') IS NOT NULL DROP TABLE KhachHang;
IF OBJECT_ID(N'NhaCungCap', N'U') IS NOT NULL DROP TABLE NhaCungCap;
IF OBJECT_ID(N'KichThuoc', N'U') IS NOT NULL DROP TABLE KichThuoc;
IF OBJECT_ID(N'ChatLieu', N'U') IS NOT NULL DROP TABLE ChatLieu;
IF OBJECT_ID(N'NuocSanXuat', N'U') IS NOT NULL DROP TABLE NuocSanXuat;
IF OBJECT_ID(N'MauSac', N'U') IS NOT NULL DROP TABLE MauSac;
GO

-- ==========================================================================================
-- 3. TẠO CÁC BẢNG DANH MỤC (BẢNG ĐƠN)
-- ==========================================================================================

-- 3.1. Bảng Kích thước (A8-A10)
CREATE TABLE KichThuoc (
    MaKichThuoc NVARCHAR(20) PRIMARY KEY,
    TenKichThuoc NVARCHAR(50) NOT NULL
);
GO

-- 3.2. Bảng Chất liệu (A14-A16)
CREATE TABLE ChatLieu (
    MaChatLieu NVARCHAR(20) PRIMARY KEY,
    TenChatLieu NVARCHAR(50) NOT NULL
);
GO

-- 3.3. Bảng Nước sản xuất (A19-A21)
CREATE TABLE NuocSanXuat (
    MaNuocSX NVARCHAR(20) PRIMARY KEY,
    TenNuocSX NVARCHAR(50) NOT NULL
);
GO

-- 3.4. Bảng Màu sắc (A23-A25)
CREATE TABLE MauSac (
    MaMau NVARCHAR(20) PRIMARY KEY,
    TenMau NVARCHAR(50) NOT NULL
);
GO

-- 3.5. Bảng Công việc (E28-E31)
CREATE TABLE CongViec (
    MaCV NVARCHAR(20) PRIMARY KEY,
    TenCV NVARCHAR(100) NOT NULL,
    MucLuong DECIMAL(18, 0) DEFAULT 0
);
GO

-- 3.6. Bảng Khách hàng (E22-E26)
CREATE TABLE KhachHang (
    MaKhach NVARCHAR(20) PRIMARY KEY,
    TenKhach NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200) NULL,
    DienThoai NVARCHAR(20) NULL
);
GO

-- 3.7. Bảng Nhà cung cấp (G23-G27)
CREATE TABLE NhaCungCap (
    MaNCC NVARCHAR(20) PRIMARY KEY,
    TenNCC NVARCHAR(150) NOT NULL,
    DiaChi NVARCHAR(200) NULL,
    DienThoai NVARCHAR(20) NULL
);
GO

-- ==========================================================================================
-- 4. TẠO CÁC BẢNG CHÍNH (CÓ KHÓA NGOẠI)
-- ==========================================================================================

-- 4.1. Bảng Nhân viên (C22-C29)
CREATE TABLE NhanVien (
    MaNV NVARCHAR(20) PRIMARY KEY,
    TenNV NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) NULL,
    NgaySinh DATE NULL,
    DienThoai NVARCHAR(20) NULL,
    DiaChi NVARCHAR(200) NULL,
    MaCV NVARCHAR(20) NULL,
    CONSTRAINT FK_NhanVien_CongViec FOREIGN KEY (MaCV) REFERENCES CongViec(MaCV)
        ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- 4.2. Bảng Danh mục hàng hoá (C8-C20)
CREATE TABLE DMHangHoa (
    MaHang NVARCHAR(20) PRIMARY KEY,
    TenHang NVARCHAR(150) NOT NULL,
    MaKichThuoc NVARCHAR(20) NULL,
    MaChatLieu NVARCHAR(20) NULL,
    MaMau NVARCHAR(20) NULL,
    MaNuocSX NVARCHAR(20) NULL,
    SoLuong INT DEFAULT 0,
    GiaNhap DECIMAL(18, 2) DEFAULT 0,
    DonGiaBan DECIMAL(18, 2) DEFAULT 0,
    ThoiGianBaoHanh NVARCHAR(50) NULL,
    Anh NVARCHAR(255) NULL,
    GhiChu NVARCHAR(500) NULL,
    CONSTRAINT FK_DMHangHoa_KichThuoc FOREIGN KEY (MaKichThuoc) REFERENCES KichThuoc(MaKichThuoc)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_DMHangHoa_ChatLieu FOREIGN KEY (MaChatLieu) REFERENCES ChatLieu(MaChatLieu)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_DMHangHoa_MauSac FOREIGN KEY (MaMau) REFERENCES MauSac(MaMau)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_DMHangHoa_NuocSX FOREIGN KEY (MaNuocSX) REFERENCES NuocSanXuat(MaNuocSX)
        ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- 4.3. Bảng Hóa đơn bán (E8-E13)
CREATE TABLE HoaDonBan (
    SoHDB NVARCHAR(20) PRIMARY KEY,
    MaNV NVARCHAR(20) NULL,
    NgayBan DATE DEFAULT GETDATE(),
    MaKhach NVARCHAR(20) NULL,
    TongTien DECIMAL(18, 2) DEFAULT 0,
    CONSTRAINT FK_HoaDonBan_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_HoaDonBan_KhachHang FOREIGN KEY (MaKhach) REFERENCES KhachHang(MaKhach)
        ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- 4.4. Bảng Chi tiết hoá đơn bán (G8-G13)
CREATE TABLE ChiTietHoaDonBan (
    SoHDB NVARCHAR(20) NOT NULL,
    MaHang NVARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    GiamGia FLOAT DEFAULT 0,      -- % giảm giá (ví dụ: 0, 5, 10)
    ThanhTien DECIMAL(18, 2) DEFAULT 0,
    PRIMARY KEY (SoHDB, MaHang),
    CONSTRAINT FK_ChiTietHDBan_HoaDon FOREIGN KEY (SoHDB) REFERENCES HoaDonBan(SoHDB)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_ChiTietHDBan_HangHoa FOREIGN KEY (MaHang) REFERENCES DMHangHoa(MaHang)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- 4.5. Bảng Hoá đơn nhập (E15-E20)
CREATE TABLE HoaDonNhap (
    SoHDN NVARCHAR(20) PRIMARY KEY,
    MaNV NVARCHAR(20) NULL,
    NgayNhap DATE DEFAULT GETDATE(),
    MaNCC NVARCHAR(20) NULL,
    TongTien DECIMAL(18, 2) DEFAULT 0,
    CONSTRAINT FK_HoaDonNhap_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_HoaDonNhap_NCC FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
        ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- 4.6. Bảng Chi tiết hoá đơn nhập (G15-G21)
CREATE TABLE ChiTietHoaDonNhap (
    SoHDN NVARCHAR(20) NOT NULL,
    MaHang NVARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18, 2) NOT NULL CHECK (DonGia >= 0),
    GiamGia FLOAT DEFAULT 0,      -- % giảm giá (ví dụ: 0, 5, 10)
    ThanhTien DECIMAL(18, 2) DEFAULT 0,
    PRIMARY KEY (SoHDN, MaHang),
    CONSTRAINT FK_ChiTietHDNhap_HoaDon FOREIGN KEY (SoHDN) REFERENCES HoaDonNhap(SoHDN)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_ChiTietHDNhap_HangHoa FOREIGN KEY (MaHang) REFERENCES DMHangHoa(MaHang)
        ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- 4.7. Bảng Tài khoản người dùng (Phân quyền Admin & Khách hàng theo Yêu cầu 3.1 & Model TaiKhoan.cs)
CREATE TABLE TaiKhoan (
    TenDangNhap NVARCHAR(50) PRIMARY KEY,
    MatKhau NVARCHAR(255) NOT NULL,
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    SoDienThoai NVARCHAR(20) NULL,
    DiaChi NVARCHAR(200) NULL,
    Quyen NVARCHAR(20) NOT NULL DEFAULT N'KhachHang', -- 'Admin' hoặc 'KhachHang'
    MaKhach NVARCHAR(20) NULL,
    MaNV NVARCHAR(20) NULL,
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_TaiKhoan_KhachHang FOREIGN KEY (MaKhach) REFERENCES KhachHang(MaKhach)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_TaiKhoan_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
        ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- ==========================================================================================
-- 5. CÁC TRIGGER ĐÁP ỨNG NGHIỆP VỤ TỰ ĐỘNG CỦA FILE EXCEL (Dòng 33 - 35)
-- ==========================================================================================

-- Yêu cầu 1, 2, 3:
-- 1. Số lượng trong DM hàng hoá được tự động cập nhật khi nhập hàng và bán hàng
-- 2. Giá nhập trong DM hàng hoá được tự động cập nhật khi nhập hàng
-- 3. Giá bán trong DM hàng hoá được tự động cập nhật = 110% Giá nhập

-- 5.1. Trigger trên ChiTietHoaDonNhap (Cập nhật Số lượng, Giá nhập, Giá bán = 110% Giá nhập, và Tổng tiền HDN)
CREATE OR ALTER TRIGGER trg_ChiTietHoaDonNhap_UpdateHangHoa
ON ChiTietHoaDonNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Tự động tính Thành Tiền cho ChiTietHoaDonNhap nếu có bản ghi thêm/sửa
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE ct
        SET ct.ThanhTien = i.SoLuong * i.DonGia * (1.0 - ISNULL(i.GiamGia, 0) / 100.0)
        FROM ChiTietHoaDonNhap ct
        JOIN inserted i ON ct.SoHDN = i.SoHDN AND ct.MaHang = i.MaHang;
    END

    -- Cập nhật Số lượng tồn kho: Cộng số lượng nhập mới, trừ số lượng bị xóa/sửa
    -- Cập nhật Giá nhập mới nhất và tự động cập nhật Giá bán = 110% Giá nhập
    ;WITH ThongTinCapNhat AS (
        SELECT 
            MaHang, 
            SUM(SoLuongChenhLech) AS TongThayDoiSL,
            MAX(GiaNhapMoi) AS GiaNhapMoiNhat
        FROM (
            SELECT MaHang, SoLuong AS SoLuongChenhLech, DonGia AS GiaNhapMoi FROM inserted
            UNION ALL
            SELECT MaHang, -SoLuong AS SoLuongChenhLech, NULL AS GiaNhapMoi FROM deleted
        ) AS Tmp
        GROUP BY MaHang
    )
    UPDATE h
    SET 
        h.SoLuong = ISNULL(h.SoLuong, 0) + t.TongThayDoiSL,
        h.GiaNhap = CASE WHEN t.GiaNhapMoiNhat IS NOT NULL THEN t.GiaNhapMoiNhat ELSE h.GiaNhap END,
        h.DonGiaBan = CASE 
                        WHEN t.GiaNhapMoiNhat IS NOT NULL THEN ROUND(t.GiaNhapMoiNhat * 1.10, 2) 
                        ELSE h.DonGiaBan 
                      END
    FROM DMHangHoa h
    JOIN ThongTinCapNhat t ON h.MaHang = t.MaHang;

    -- Cập nhật lại Tổng Tiền cho Hóa Đơn Nhập tương ứng
    UPDATE hdn
    SET TongTien = ISNULL((
        SELECT SUM(ThanhTien)
        FROM ChiTietHoaDonNhap ct
        WHERE ct.SoHDN = hdn.SoHDN
    ), 0)
    FROM HoaDonNhap hdn
    WHERE hdn.SoHDN IN (
        SELECT DISTINCT SoHDN FROM inserted
        UNION
        SELECT DISTINCT SoHDN FROM deleted
    );
END;
GO

-- 5.2. Trigger trên ChiTietHoaDonBan (Cập nhật Số lượng khi bán hàng, tự động tính Thành tiền, Tổng tiền HDB)
CREATE OR ALTER TRIGGER trg_ChiTietHoaDonBan_UpdateHangHoa
ON ChiTietHoaDonBan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Tự động tính Thành Tiền cho ChiTietHoaDonBan dựa trên Đơn giá bán của hàng hóa
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE ct
        SET ct.ThanhTien = i.SoLuong * ISNULL(h.DonGiaBan, 0) * (1.0 - ISNULL(i.GiamGia, 0) / 100.0)
        FROM ChiTietHoaDonBan ct
        JOIN inserted i ON ct.SoHDB = i.SoHDB AND ct.MaHang = i.MaHang
        JOIN DMHangHoa h ON ct.MaHang = h.MaHang;
    END

    -- Cập nhật Số lượng tồn kho: Trừ số lượng bán, cộng lại nếu hóa đơn bị xóa/hủy
    ;WITH ThayDoiSL AS (
        SELECT 
            MaHang, 
            SUM(SoLuongChenhLech) AS TongThayDoiSL
        FROM (
            SELECT MaHang, -SoLuong AS SoLuongChenhLech FROM inserted
            UNION ALL
            SELECT MaHang, SoLuong AS SoLuongChenhLech FROM deleted
        ) AS Tmp
        GROUP BY MaHang
    )
    UPDATE h
    SET h.SoLuong = ISNULL(h.SoLuong, 0) + t.TongThayDoiSL
    FROM DMHangHoa h
    JOIN ThayDoiSL t ON h.MaHang = t.MaHang;

    -- Cập nhật lại Tổng Tiền cho Hóa Đơn Bán tương ứng
    UPDATE hdb
    SET TongTien = ISNULL((
        SELECT SUM(ThanhTien)
        FROM ChiTietHoaDonBan ct
        WHERE ct.SoHDB = hdb.SoHDB
    ), 0)
    FROM HoaDonBan hdb
    WHERE hdb.SoHDB IN (
        SELECT DISTINCT SoHDB FROM inserted
        UNION
        SELECT DISTINCT SoHDB FROM deleted
    );
END;
GO

-- 5.3. Trigger bổ trợ trên DMHangHoa: Khi cập nhật Giá nhập thủ công thì Giá bán tự động cập nhật = 110% Giá nhập
CREATE OR ALTER TRIGGER trg_DMHangHoa_AutoUpdateDonGiaBan
ON DMHangHoa
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(GiaNhap)
    BEGIN
        UPDATE h
        SET h.DonGiaBan = ROUND(i.GiaNhap * 1.10, 2)
        FROM DMHangHoa h
        JOIN inserted i ON h.MaHang = i.MaHang
        WHERE i.GiaNhap IS NOT NULL;
    END
END;
GO

-- ==========================================================================================
-- 6. CÁC STORED PROCEDURE & TRUY VẤN THEO YÊU CẦU ĐỀ BÀI (Dòng 36 - 41)
-- ==========================================================================================

-- Yêu cầu 4: Tìm kiếm sản phẩm theo: chất liệu, nước sx, thời gian bảo hành
CREATE OR ALTER PROCEDURE sp_TimKiemSanPham
    @MaChatLieu NVARCHAR(20) = NULL,
    @MaNuocSX NVARCHAR(20) = NULL,
    @ThoiGianBaoHanh NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        h.MaHang,
        h.TenHang,
        kt.TenKichThuoc,
        cl.TenChatLieu,
        ms.TenMau,
        nsx.TenNuocSX,
        h.SoLuong,
        h.GiaNhap,
        h.DonGiaBan,
        h.ThoiGianBaoHanh,
        h.Anh,
        h.GhiChu
    FROM DMHangHoa h
    LEFT JOIN KichThuoc kt ON h.MaKichThuoc = kt.MaKichThuoc
    LEFT JOIN ChatLieu cl ON h.MaChatLieu = cl.MaChatLieu
    LEFT JOIN MauSac ms ON h.MaMau = ms.MaMau
    LEFT JOIN NuocSanXuat nsx ON h.MaNuocSX = nsx.MaNuocSX
    WHERE (@MaChatLieu IS NULL OR @MaChatLieu = '' OR h.MaChatLieu = @MaChatLieu)
      AND (@MaNuocSX IS NULL OR @MaNuocSX = '' OR h.MaNuocSX = @MaNuocSX)
      AND (@ThoiGianBaoHanh IS NULL OR @ThoiGianBaoHanh = '' OR h.ThoiGianBaoHanh LIKE N'%' + @ThoiGianBaoHanh + '%');
END;
GO

-- Yêu cầu 5: Tìm kiếm các HĐ bán theo: mã hàng, ngày bán, tổng tiền
CREATE OR ALTER PROCEDURE sp_TimKiemHoaDonBan
    @MaHang NVARCHAR(20) = NULL,
    @NgayBan DATE = NULL,
    @TongTienTu DECIMAL(18, 2) = NULL,
    @TongTienDen DECIMAL(18, 2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT
        hdb.SoHDB,
        hdb.NgayBan,
        nv.TenNV,
        kh.TenKhach,
        hdb.TongTien
    FROM HoaDonBan hdb
    LEFT JOIN NhanVien nv ON hdb.MaNV = nv.MaNV
    LEFT JOIN KhachHang kh ON hdb.MaKhach = kh.MaKhach
    LEFT JOIN ChiTietHoaDonBan ct ON hdb.SoHDB = ct.SoHDB
    WHERE (@MaHang IS NULL OR @MaHang = '' OR ct.MaHang = @MaHang)
      AND (@NgayBan IS NULL OR hdb.NgayBan = @NgayBan)
      AND (@TongTienTu IS NULL OR hdb.TongTien >= @TongTienTu)
      AND (@TongTienDen IS NULL OR hdb.TongTien <= @TongTienDen);
END;
GO

-- Yêu cầu 6: Báo cáo danh sách 3 sản phẩm bán được nhiều nhất trong một quý chọn trước
CREATE OR ALTER PROCEDURE sp_BaoCaoTop3SanPhamTheoQuy
    @Nam INT,
    @Quy INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 3
        h.MaHang,
        h.TenHang,
        cl.TenChatLieu,
        ms.TenMau,
        SUM(ct.SoLuong) AS TongSoLuongBan,
        SUM(ct.ThanhTien) AS TongDoanhThu
    FROM ChiTietHoaDonBan ct
    JOIN HoaDonBan hdb ON ct.SoHDB = hdb.SoHDB
    JOIN DMHangHoa h ON ct.MaHang = h.MaHang
    LEFT JOIN ChatLieu cl ON h.MaChatLieu = cl.MaChatLieu
    LEFT JOIN MauSac ms ON h.MaMau = ms.MaMau
    WHERE YEAR(hdb.NgayBan) = @Nam 
      AND DATEPART(QUARTER, hdb.NgayBan) = @Quy
    GROUP BY h.MaHang, h.TenHang, cl.TenChatLieu, ms.TenMau
    ORDER BY TongSoLuongBan DESC;
END;
GO

-- Yêu cầu 7: Báo cáo chi tiết danh sách các hoá đơn nhập do một nhân viên nhập được chọn trước
CREATE OR ALTER PROCEDURE sp_BaoCaoHoaDonNhapTheoNV
    @MaNV NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        hdn.SoHDN,
        hdn.NgayNhap,
        nv.MaNV,
        nv.TenNV,
        ncc.TenNCC,
        h.MaHang,
        h.TenHang,
        ct.SoLuong,
        ct.DonGia,
        ct.GiamGia,
        ct.ThanhTien,
        hdn.TongTien AS TongTienHoaDon
    FROM HoaDonNhap hdn
    JOIN NhanVien nv ON hdn.MaNV = nv.MaNV
    LEFT JOIN NhaCungCap ncc ON hdn.MaNCC = ncc.MaNCC
    JOIN ChiTietHoaDonNhap ct ON hdn.SoHDN = ct.SoHDN
    JOIN DMHangHoa h ON ct.MaHang = h.MaHang
    WHERE hdn.MaNV = @MaNV
    ORDER BY hdn.NgayNhap DESC, hdn.SoHDN;
END;
GO

-- Yêu cầu 8: Báo cáo chi tiết danh sách 5 hoá đơn có tổng tiền bán hàng nhỏ nhất theo quý chọn trước
CREATE OR ALTER PROCEDURE sp_BaoCaoTop5HDBanNhoNhatTheoQuy
    @Nam INT,
    @Quy INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 5
        hdb.SoHDB,
        hdb.NgayBan,
        nv.TenNV,
        kh.TenKhach,
        hdb.TongTien
    FROM HoaDonBan hdb
    LEFT JOIN NhanVien nv ON hdb.MaNV = nv.MaNV
    LEFT JOIN KhachHang kh ON hdb.MaKhach = kh.MaKhach
    WHERE YEAR(hdb.NgayBan) = @Nam 
      AND DATEPART(QUARTER, hdb.NgayBan) = @Quy
    ORDER BY hdb.TongTien ASC;
END;
GO

-- Yêu cầu 9: Báo cáo danh sách các khách hàng mua hàng theo tháng chọn trước
CREATE OR ALTER PROCEDURE sp_BaoCaoKhachHangTheoThang
    @Nam INT,
    @Thang INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT
        kh.MaKhach,
        kh.TenKhach,
        kh.DiaChi,
        kh.DienThoai,
        COUNT(hdb.SoHDB) AS SoLuotMua,
        SUM(hdb.TongTien) AS TongTienMua
    FROM KhachHang kh
    JOIN HoaDonBan hdb ON kh.MaKhach = hdb.MaKhach
    WHERE YEAR(hdb.NgayBan) = @Nam 
      AND MONTH(hdb.NgayBan) = @Thang
    GROUP BY kh.MaKhach, kh.TenKhach, kh.DiaChi, kh.DienThoai
    ORDER BY TongTienMua DESC;
END;
GO

-- ==========================================================================================

-- ==========================================================================================
-- Dá»® LIá»†U Äáº¦Y Äá»¦ Cá»¦A TOÃ€N Bá»˜ DATABASE QuanLyBanTuBep (LIVE EXPORT)
-- Thá»i Ä‘iá»ƒm xuáº¥t: 2026-11-04 12:27:26
-- CÆ¡ sá»Ÿ dá»¯ liá»‡u: Microsoft SQL Server (MSSQLLocalDB)
-- ==========================================================================================
USE QuanLyBanTuBep;
GO

-- Táº¯t táº¡m thá»i cÃ¡c Foreign Key vÃ  Trigger Ä‘á»ƒ import dá»¯ liá»‡u chuáº©n xÃ¡c khÃ´ng bá»‹ xung Ä‘á»™t
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
EXEC sp_MSforeachtable 'ALTER TABLE ? DISABLE TRIGGER ALL';
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: KichThuoc (7 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [KichThuoc] ([MaKichThuoc], [TenKichThuoc]) VALUES
(N'KT01', N'Dài 1.2m x Sâu 0.6m'),
(N'KT02', N'Dài 1.5m x Sâu 0.6m'),
(N'KT03', N'Dài 2.0m x Sâu 0.6m'),
(N'KT04', N'Dài 2.4m x Sâu 0.6m'),
(N'KT05', N'Thiết kế theo yêu cầu'),
(N'KT06', N'Chữ L (Dài 3.0m x Sâu 0.6m)'),
(N'KT07', N'Chữ U có bàn đảo (Dài 3.6m)');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: ChatLieu (7 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [ChatLieu] ([MaChatLieu], [TenChatLieu]) VALUES
(N'CL01', N'Gỗ công nghiệp MDF lõi xanh'),
(N'CL02', N'Gỗ Acrylic bóng gương'),
(N'CL03', N'Inox 304 cánh kính'),
(N'CL04', N'Gỗ Sồi Nga tự nhiên'),
(N'CL05', N'Nhựa cao cấp Picomat'),
(N'CL06', N'Gỗ Óc Chó (Walnut) tự nhiên'),
(N'CL07', N'Gỗ Xoan Đào Gia Lai');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: NuocSanXuat (6 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [NuocSanXuat] ([MaNuocSX], [TenNuocSX]) VALUES
(N'CN', N'Trung Quốc'),
(N'DE', N'Đức'),
(N'HQ', N'Hàn Quốc'),
(N'IT', N'Italia (Ý)'),
(N'NB', N'Nhật Bản'),
(N'VN', N'Việt Nam');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: MauSac (8 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [MauSac] ([MaMau], [TenMau]) VALUES
(N'M01', N'Trắng sứ'),
(N'M02', N'Xám ghi'),
(N'M03', N'Vân gỗ sồi'),
(N'M04', N'Đen mờ'),
(N'M05', N'Xanh rêu pastel'),
(N'M06', N'Nâu hạt dẻ / Óc chó'),
(N'M07', N'Trắng ngọc trai phối xám'),
(N'M08', N'Xanh Navy hoàng gia');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: CongViec (4 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [CongViec] ([MaCV], [TenCV], [MucLuong]) VALUES
(N'CV01', N'Quản lý cửa hàng', 18000000),
(N'CV02', N'Nhân viên bán hàng', 8000000),
(N'CV03', N'Nhân viên kỹ thuật - lắp đặt', 10000000),
(N'CV04', N'Kế toán kho', 9000000);
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: KhachHang (5 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [KhachHang] ([MaKhach], [TenKhach], [DiaChi], [DienThoai]) VALUES
(N'KH01', N'Đỗ Minh Tuấn', N'Vinhomes Ocean Park, Gia Lâm', N'0901112233'),
(N'KH02', N'Nguyễn Thu Trang', N'EcoPark, Hưng Yên', N'0902223344'),
(N'KH03', N'Vũ Đình Hưng', N'Royal City, Thanh Xuân, Hà Nội', N'0903334455'),
(N'KH04', N'Lê Mai Phương', N'Times City, Hai Bà Trưng, Hà Nội', N'0904445566'),
(N'KH05', N'Đỗ Minh Tuấn', NULL, N'0901112233');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: NhaCungCap (3 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [NhaCungCap] ([MaNCC], [TenNCC], [DiaChi], [DienThoai]) VALUES
(N'NCC01', N'Công ty Cổ phần Gỗ An Cường', N'Bình Dương', N'02743888999'),
(N'NCC02', N'Công ty TNHH Nhựa Picomat', N'Hà Nội', N'0243666777'),
(N'NCC03', N'Tập đoàn Hafele Việt Nam', N'TP. Hồ Chí Minh', N'0283999888');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: NhanVien (4 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [NhanVien] ([MaNV], [TenNV], [GioiTinh], [NgaySinh], [DienThoai], [DiaChi], [MaCV]) VALUES
(N'NV01', N'Nguyễn Văn An', N'Nam', '1992-05-15 00:00:00.000', N'0912345678', N'Cầu Giấy, Hà Nội', N'CV01'),
(N'NV02', N'Trần Thị Bích', N'Nữ', '1996-08-20 00:00:00.000', N'0923456789', N'Đống Đa, Hà Nội', N'CV02'),
(N'NV03', N'Lê Hoàng Long', N'Nam', '1995-12-10 00:00:00.000', N'0934567890', N'Hà Đông, Hà Nội', N'CV03'),
(N'NV04', N'Phạm Thu Hà', N'Nữ', '1998-03-25 00:00:00.000', N'0945678901', N'Thanh Xuân, Hà Nội', N'CV04');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: DMHangHoa (20 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [DMHangHoa] ([MaHang], [TenHang], [MaKichThuoc], [MaChatLieu], [MaMau], [MaNuocSX], [SoLuong], [GiaNhap], [DonGiaBan], [ThoiGianBaoHanh], [Anh], [GhiChu]) VALUES
(N'TB01', N'Tủ Bếp Nhựa PVC Cánh Phủ Acrylic Bóng Gương An Cường Chữ I', N'KT03', N'CL05', N'M01', N'VN', 8, 12000000.00, 13200000.00, N'60 tháng', N'tu_bep_01.jpg;tu_bep_01_angle.jpg;tu_bep_01_detail.jpg;tu_bep_01_inside.jpg', N'Thùng tủ nhựa PVC đặc 18mm chịu nước 100%, cánh phủ Acrylic noline bóng gương An Cường, bản lề giảm chấn inox 304.'),
(N'TB02', N'Tủ Bếp Inox 304 Khung Hộp Cánh Kính Cường Lực Viền Nhôm', N'KT04', N'CL03', N'M02', N'DE', 7, 22000000.00, 24200000.00, N'60 tháng', N'tu_bep_02.jpg;tu_bep_02_angle.jpg;tu_bep_02_detail.jpg;tu_bep_02_inside.jpg', N'Khung inox hộp chuẩn SUS 304 dập chấn CNC cao cấp không mối hàn, cánh kính cường lực 4mm viền nhôm Anode tràn viền sang trọng.'),
(N'TB03', N'Tủ Bếp Gỗ Sồi Nga Tự Nhiên Sơn PU Màu Hạt Dẻ Bắc Âu', N'KT03', N'CL04', N'M03', N'NB', 6, 16500000.00, 18150000.00, N'36 tháng', N'tu_bep_03.jpg;tu_bep_03_angle.jpg;tu_bep_03_detail.jpg;tu_bep_03_inside.jpg', N'100% gỗ Sồi Nga tự nhiên đã tẩm sấy công nghệ cao chống co ngót nứt nẻ, sơn lót PU 5 lớp giữ trọn vân gỗ uốn lượn.'),
(N'TB04', N'Tủ Bếp Gỗ MDF Lõi Xanh Chống Ẩm Phủ Melamine Chữ I', N'KT03', N'CL01', N'M04', N'VN', 16, 9500000.00, 10450000.00, N'24 tháng', N'tu_bep_04.jpg;tu_bep_04_angle.jpg;tu_bep_04_detail.jpg;tu_bep_04_inside.jpg', N'Cốt gỗ MDF lõi xanh chống ẩm tiêu chuẩn E1 An Cường, bề mặt phủ Melamine chống trầy xước, giải pháp tối ưu cho chung cư.'),
(N'TB05', N'Tủ Bếp Nhựa PVC Sơn Men Bóng Ô Tô Công Nghệ Ánh Kim Chữ L', N'KT06', N'CL05', N'M05', N'VN', 7, 15000000.00, 16500000.00, N'60 tháng', N'tu_bep_05.jpg;tu_bep_05_angle.jpg;tu_bep_05_detail.jpg;tu_bep_05_inside.jpg', N'Sơn men bóng ô tô cao cấp ánh kim độc quyền Xuyên Việt, line 2 màu xanh pastel dịu mắt, bo viền cạnh tinh tế chống ẩm tuyệt đối.'),
(N'TB06', N'Tủ Bếp Inox 304 Cánh Kính Vân Khói Hút Khử Mùi Kịch Trần', N'KT06', N'CL03', N'M04', N'DE', 8, 28000000.00, 30800000.00, N'60 tháng', N'tu_bep_06.jpg;tu_bep_06_angle.jpg;tu_bep_06_detail.jpg;tu_bep_06_inside.jpg', N'Thiết kế kịch trần nhân đôi không gian chứa đồ, cánh kính màu khói phản quang sang trọng, kháng nước và chống cháy hoàn hảo.'),
(N'TB07', N'Tủ Bếp Gỗ Óc Chó (Walnut) Nhập Khẩu Bắc Mỹ Phong Cách Hoàng Gia', N'KT07', N'CL06', N'M06', N'VN', 4, 45000000.00, 49500000.00, N'60 tháng', N'tu_bep_07.jpg;tu_bep_07_angle.jpg;tu_bep_07_detail.jpg;tu_bep_07_inside.jpg', N'Dòng gỗ thượng lưu màu nâu socola trầm ấm, hệ vân cuộn xoáy tự nhiên cuốn hút, hoàn thiện thủ công sơn Inchem 6 lớp đỉnh cao.'),
(N'TB08', N'Tủ Bếp Chữ L MDF Chống Ẩm Phủ Melamine Kết Hợp Acrylic', N'KT06', N'CL01', N'M03', N'VN', 15, 13500000.00, 14850000.00, N'24 tháng', N'tu_bep_08.jpg;tu_bep_08_angle.jpg;tu_bep_08_detail.jpg;tu_bep_08_inside.jpg', N'Tủ dưới phủ Melamine chống xước chống va đập, tủ trên Acrylic bóng gương tạo độ tương phản thời thượng cho góc bếp chữ L.'),
(N'TB09', N'Tủ Bếp Acrylic Kịch Trần 2 Tầng Tối Đa Không Gian Chứa Đồ', N'KT04', N'CL02', N'M07', N'HQ', 8, 18500000.00, 20350000.00, N'36 tháng', N'tu_bep_09.jpg;tu_bep_09_angle.jpg;tu_bep_09_detail.jpg;tu_bep_09_inside.jpg', N'Thiết kế 2 tầng kịch trần hiện đại, tay nắm âm nhôm chữ J tinh tế không vướng víu, cánh phủ Acrylic bóng sáng như gương.'),
(N'TB10', N'Tủ Bếp Nhựa PVC Phủ Laminate Vân Đá Chống Xước Cao Cấp', N'KT04', N'CL05', N'M02', N'VN', 9, 16500000.00, 18150000.00, N'60 tháng', N'tu_bep_10.jpg;tu_bep_10_angle.jpg;tu_bep_10_detail.jpg;tu_bep_10_inside.jpg', N'Thùng nhựa PVC đặc chống nước tuyệt đối, cánh phủ Laminate vân đá sần chống trầy xước và chịu nhiệt vượt trội.'),
(N'TB11', N'Tủ Bếp Tân Cổ Điển Gỗ Tự Nhiên Sơn Men Trắng Sứ Nhập Khẩu', N'KT06', N'CL04', N'M01', N'IT', 6, 32000000.00, 35200000.00, N'36 tháng', N'tu_bep_11.jpg;tu_bep_11_angle.jpg;tu_bep_11_detail.jpg;tu_bep_11_inside.jpg', N'Chạm khắc soi huỳnh viền chỉ tỉ mỉ phong cách quý tộc Châu Âu, mặt đá cẩm thạch Ý sang trọng, hệ phụ kiện giảm chấn cao cấp.'),
(N'TB12', N'Tủ Bếp Gỗ Xoan Đào Gia Lai Chọn Vân Vân Gỗ Đều Màu', N'KT02', N'CL07', N'M06', N'VN', 7, 12000000.00, 13200000.00, N'24 tháng', N'tu_bep_12.jpg;tu_bep_12_angle.jpg;tu_bep_12_detail.jpg;tu_bep_12_inside.jpg', N'Gỗ Xoan Đào tự nhiên chọn lọc đanh chắc, chịu lực tốt, màu sắc cánh gián ấm cúng, hương thơm tự nhiên xua đuổi côn trùng.'),
(N'TB13', N'Tủ Bếp Inox Hệ Module Rời Cánh Hợp Kim Nhôm Cao Cấp', N'KT04', N'CL03', N'M02', N'NB', 4, 26500000.00, 29150000.00, N'60 tháng', N'tu_bep_13.jpg;tu_bep_13_angle.jpg;tu_bep_13_detail.jpg;tu_bep_13_inside.jpg', N'Module inox độc lập công nghệ Nhật Bản tháo lắp linh hoạt, chống cong vênh và chống rỉ sét vĩnh cửu trong môi trường ẩm.'),
(N'TB14', N'Tủ Bếp Chữ U Acrylic Phối Bàn Đảo & Quầy Bar Mini', N'KT07', N'CL02', N'M08', N'IT', 4, 42000000.00, 46200000.00, N'36 tháng', N'tu_bep_14.jpg;tu_bep_14_angle.jpg;tu_bep_14_detail.jpg;tu_bep_14_inside.jpg', N'Không gian nấu nướng chuẩn công thái học tam giác vàng, tone xanh Navy hoàng gia sang trọng, quầy bar thưởng rượu lý tưởng.'),
(N'TB15', N'Tủ Bếp Mini Studio 1m2 Tích Hợp Phụ Kiện Rút Thông Minh', N'KT01', N'CL01', N'M01', N'VN', 15, 7500000.00, 8250000.00, N'12 tháng', N'tu_bep_15.jpg;tu_bep_15_angle.jpg;tu_bep_15_detail.jpg;tu_bep_15_inside.jpg', N'Tối ưu từng milimet cho căn hộ studio: giá dao thớt gia vị rút, thùng gạo âm tủ, ngăn chia thìa dĩa và chậu rửa mini tiện lợi.'),
(N'TB16', N'Tủ Bếp Gỗ Sồi Cánh Nan Chớp Thông Gió Chống Ẩm Mốc', N'KT03', N'CL04', N'M03', N'NB', 6, 16000000.00, 17600000.00, N'24 tháng', N'tu_bep_16.jpg;tu_bep_16_angle.jpg;tu_bep_16_detail.jpg;tu_bep_16_inside.jpg', N'Thiết kế cánh nan chớp lưu thông không khí, giữ khoang gia vị và bát đĩa khô thoáng, chống ẩm mốc trong mùa nồm miền Bắc.'),
(N'TB17', N'Tủ Bếp Nhựa PVC Cánh Bo Viền Nghệ Thuật Phối Quầy Bar', N'KT07', N'CL05', N'M07', N'VN', 5, 22000000.00, 24200000.00, N'60 tháng', N'tu_bep_17.jpg;tu_bep_17_angle.jpg;tu_bep_17_detail.jpg;tu_bep_17_inside.jpg', N'Tích hợp quầy bar gia đình và tủ rượu cánh kính đèn LED sang trọng, công nghệ bo góc nghệ thuật mềm mại và an toàn.'),
(N'TB18', N'Tủ Bếp Chữ L Inox Cánh Kính Cường Lực Sơn Nhiệt Ceramic', N'KT06', N'CL03', N'M04', N'DE', 6, 31000000.00, 34100000.00, N'60 tháng', N'tu_bep_18.jpg;tu_bep_18_angle.jpg;tu_bep_18_detail.jpg;tu_bep_18_inside.jpg', N'Mặt kính cường lực hấp nhiệt men gốm ceramic chống xước và chịu sốc nhiệt lên tới 300 độ C, khung inox 304 chống mối mọt trọn đời.'),
(N'TB19', N'Tủ Bếp Sơn Men Màu Pastel Xanh Sage Mát Mẻ', N'KT03', N'CL01', N'M05', N'VN', 9, 11200000.00, 12320000.00, N'24 tháng', N'tu_bep_19.jpg;tu_bep_19_angle.jpg;tu_bep_19_detail.jpg;tu_bep_19_inside.jpg', N'Gam màu xanh Sage pastel dịu mát, phong cách Scandinavian trẻ trung giúp căn bếp luôn tràn ngập năng lượng tươi mới.'),
(N'TB20', N'Tủ Bếp Biệt Thự Inox 304 Luxury Tích Hợp Đèn LED Cảm Ứng Bàn Đảo', N'KT07', N'CL03', N'M08', N'DE', 3, 55000000.00, 60500000.00, N'60 tháng', N'tu_bep_20.jpg;tu_bep_20_angle.jpg;tu_bep_20_detail.jpg;tu_bep_20_inside.jpg', N'Dòng siêu phẩm dành cho biệt thự: bàn đảo 3m6, hệ thống ray trượt Blum điện tích hợp LED cảm ứng vẫy tay tự động cao cấp.');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: TaiKhoan (3 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [TaiKhoan] ([TenDangNhap], [MatKhau], [HoTen], [Email], [SoDienThoai], [DiaChi], [Quyen], [MaKhach], [MaNV], [TrangThai], [NgayTao]) VALUES
(N'admin', N'AQAAAAIAAYagAAAAEE7vOQ28CHznE97j9yBkYRh2NZ4ySYtFszJJ76aZd3xKB6kSB+0y9eRxB/E3UqdV9g==', N'Quản trị viên', N'admin@tubep.vn', N'0912345678', NULL, N'Admin', NULL, N'NV01', 1, '2026-10-04 08:46:39.777'),
(N'khach01', N'AQAAAAIAAYagAAAAEFZZ1KhRdkL8iVykUW3iQ1u9bgcwvuBVBpbLCeD7SZxM1EahX+39txhDYYFJ+mKeTg==', N'Đỗ Minh Tuấn', N'tuan@gmail.com', N'0901112233', NULL, N'KhachHang', N'KH01', NULL, 1, '2026-10-04 08:46:39.777'),
(N'minh1201', N'AQAAAAIAAYagAAAAEJeZp8poXhHIOFJ4eXPBKG2qxC6PzfegvCHvTwFQp2lsl2DCNkPcMKVOHEBEpUar5g==', N'Đỗ Minh Tuấn', NULL, N'0901112233', NULL, N'KhachHang', N'KH05', NULL, 1, '2026-10-19 20:21:43.137');
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: HoaDonNhap (4 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [HoaDonNhap] ([SoHDN], [MaNV], [NgayNhap], [MaNCC], [TongTien]) VALUES
(N'HDN01', N'NV04', '2026-01-10 00:00:00.000', N'NCC01', 81125000.00),
(N'HDN02', N'NV04', '2026-02-15 00:00:00.000', N'NCC02', 43120000.00),
(N'HDN03', N'NV04', '2026-03-01 00:00:00.000', N'NCC03', 199300000.00),
(N'HDN04', N'NV04', '2026-03-20 00:00:00.000', N'NCC01', 171030000.00);
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: ChiTietHoaDonNhap (7 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [ChiTietHoaDonNhap] ([SoHDN], [MaHang], [SoLuong], [DonGia], [GiamGia], [ThanhTien]) VALUES
(N'HDN01', N'TB01', 3, 12000000.00, 0, 36000000.00),
(N'HDN01', N'TB04', 5, 9500000.00, 5, 45125000.00),
(N'HDN02', N'TB02', 2, 22000000.00, 2, 43120000.00),
(N'HDN03', N'TB06', 4, 28000000.00, 0, 112000000.00),
(N'HDN03', N'TB07', 2, 45000000.00, 3, 87300000.00),
(N'HDN04', N'TB08', 6, 13500000.00, 5, 76950000.00),
(N'HDN04', N'TB11', 3, 32000000.00, 2, 94080000.00);
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: HoaDonBan (6 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [HoaDonBan] ([SoHDB], [MaNV], [NgayBan], [MaKhach], [TongTien]) VALUES
(N'HDB01', N'NV02', '2026-02-20 00:00:00.000', N'KH01', 23127500.00),
(N'HDB02', N'NV02', '2026-03-05 00:00:00.000', N'KH02', 24200000.00),
(N'HDB03', N'NV02', '2026-03-12 00:00:00.000', N'KH03', 23760000.00),
(N'HDB04', N'NV02', '2026-03-25 00:00:00.000', N'KH04', 44907500.00),
(N'HDB05', N'NV02', '2026-04-02 00:00:00.000', N'KH01', 48015000.00),
(N'HDB06', N'NV02', '2026-04-10 00:00:00.000', N'KH03', 35200000.00);
GO

-- ------------------------------------------------------------------------------------------
-- Dá»¯ liá»‡u báº£ng: ChiTietHoaDonBan (8 dÃ²ng)
-- ------------------------------------------------------------------------------------------
INSERT INTO [ChiTietHoaDonBan] ([SoHDB], [MaHang], [SoLuong], [GiamGia], [ThanhTien]) VALUES
(N'HDB01', N'TB01', 1, 0, 13200000.00),
(N'HDB01', N'TB04', 1, 5, 9927500.00),
(N'HDB02', N'TB02', 1, 0, 24200000.00),
(N'HDB03', N'TB01', 2, 10, 23760000.00),
(N'HDB04', N'TB06', 1, 0, 30800000.00),
(N'HDB04', N'TB08', 1, 5, 14107500.00),
(N'HDB05', N'TB07', 1, 3, 48015000.00),
(N'HDB06', N'TB11', 1, 0, 35200000.00);
GO

-- Báº­t láº¡i Foreign Key vÃ  Trigger sau khi Ä‘Ã£ import dá»¯ liá»‡u hoÃ n táº¥t
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
EXEC sp_MSforeachtable 'ALTER TABLE ? ENABLE TRIGGER ALL';
GO

-- ==========================================================================================
-- KIỂM TRA DỮ LIỆU VÀ CÁC NGHIỆP VỤ ĐÃ CÀI ĐẶT
-- ==========================================================================================
-- 1. Kiểm tra DM hàng hoá sau khi trigger tự cập nhật Giá bán = 110% Giá nhập:
SELECT MaHang, TenHang, SoLuong, GiaNhap, DonGiaBan FROM DMHangHoa;

-- 2. Kiểm tra Hóa đơn bán và Tổng tiền tự động:
SELECT * FROM HoaDonBan;

-- 3. Chạy thử các Store Procedure:
-- YC 4: Tìm kiếm theo chất liệu 'CL02'
EXEC sp_TimKiemSanPham @MaChatLieu = 'CL02';

-- YC 6: Top 3 sản phẩm bán nhiều nhất Quý 1 năm 2026
EXEC sp_BaoCaoTop3SanPhamTheoQuy @Nam = 2026, @Quy = 1;

-- YC 7: Danh sách hóa đơn nhập của nhân viên NV04
EXEC sp_BaoCaoHoaDonNhapTheoNV @MaNV = 'NV04';

-- YC 9: Khách hàng mua hàng trong tháng 3 năm 2026
EXEC sp_BaoCaoKhachHangTheoThang @Nam = 2026, @Thang = 3;
GO
