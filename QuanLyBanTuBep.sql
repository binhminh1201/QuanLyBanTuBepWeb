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
-- 7. CHÈN DỮ LIỆU MẪU (TEST DATA)
-- ==========================================================================================

-- 7.1. Bảng Kích thước
INSERT INTO KichThuoc (MaKichThuoc, TenKichThuoc) VALUES
('KT01', N'Dài 1.2m x Sâu 0.6m'),
('KT02', N'Dài 1.5m x Sâu 0.6m'),
('KT03', N'Dài 2.0m x Sâu 0.6m'),
('KT04', N'Dài 2.4m x Sâu 0.6m'),
('KT05', N'Thiết kế theo yêu cầu'),
('KT06', N'Chữ L (Dài 3.0m x Sâu 0.6m)'),
('KT07', N'Chữ U có bàn đảo (Dài 3.6m)');

-- 7.2. Bảng Chất liệu
INSERT INTO ChatLieu (MaChatLieu, TenChatLieu) VALUES
('CL01', N'Gỗ công nghiệp MDF lõi xanh'),
('CL02', N'Gỗ Acrylic bóng gương'),
('CL03', N'Inox 304 cánh kính'),
('CL04', N'Gỗ Sồi Nga tự nhiên'),
('CL05', N'Nhựa cao cấp Picomat'),
('CL06', N'Gỗ Óc Chó (Walnut) tự nhiên'),
('CL07', N'Gỗ Xoan Đào Gia Lai');

-- 7.3. Bảng Nước sản xuất
INSERT INTO NuocSanXuat (MaNuocSX, TenNuocSX) VALUES
('VN', N'Việt Nam'),
('HQ', N'Hàn Quốc'),
('NB', N'Nhật Bản'),
('DE', N'Đức'),
('CN', N'Trung Quốc'),
('IT', N'Italia (Ý)');

-- 7.4. Bảng Màu sắc
INSERT INTO MauSac (MaMau, TenMau) VALUES
('M01', N'Trắng sứ'),
('M02', N'Xám ghi'),
('M03', N'Vân gỗ sồi'),
('M04', N'Đen mờ'),
('M05', N'Xanh rêu pastel'),
('M06', N'Nâu hạt dẻ / Óc chó'),
('M07', N'Trắng ngọc trai phối xám'),
('M08', N'Xanh Navy hoàng gia');

-- 7.5. Bảng Công việc
INSERT INTO CongViec (MaCV, TenCV, MucLuong) VALUES
('CV01', N'Quản lý cửa hàng', 18000000),
('CV02', N'Nhân viên bán hàng', 8000000),
('CV03', N'Nhân viên kỹ thuật - lắp đặt', 10000000),
('CV04', N'Kế toán kho', 9000000);

-- 7.6. Bảng Nhân viên
INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, NgaySinh, DienThoai, DiaChi, MaCV) VALUES
('NV01', N'Nguyễn Văn An', N'Nam', '1992-05-15', '0912345678', N'Cầu Giấy, Hà Nội', 'CV01'),
('NV02', N'Trần Thị Bích', N'Nữ', '1996-08-20', '0923456789', N'Đống Đa, Hà Nội', 'CV02'),
('NV03', N'Lê Hoàng Long', N'Nam', '1995-12-10', '0934567890', N'Hà Đông, Hà Nội', 'CV03'),
('NV04', N'Phạm Thu Hà', N'Nữ', '1998-03-25', '0945678901', N'Thanh Xuân, Hà Nội', 'CV04');

-- 7.7. Bảng Khách hàng
INSERT INTO KhachHang (MaKhach, TenKhach, DiaChi, DienThoai) VALUES
('KH01', N'Đỗ Minh Tuấn', N'Vinhomes Ocean Park, Gia Lâm', '0901112233'),
('KH02', N'Nguyễn Thu Trang', N'EcoPark, Hưng Yên', '0902223344'),
('KH03', N'Vũ Đình Hưng', N'Royal City, Thanh Xuân, Hà Nội', '0903334455'),
('KH04', N'Lê Mai Phương', N'Times City, Hai Bà Trưng, Hà Nội', '0904445566');

-- 7.8. Bảng Nhà cung cấp
INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, DienThoai) VALUES
('NCC01', N'Công ty Cổ phần Gỗ An Cường', N'Bình Dương', '02743888999'),
('NCC02', N'Công ty TNHH Nhựa Picomat', N'Hà Nội', '0243666777'),
('NCC03', N'Tập đoàn Hafele Việt Nam', N'TP. Hồ Chí Minh', '0283999888');

-- 7.9. Bảng Hàng hoá (Dữ liệu tủ bếp thực tế cao cấp kèm bộ ảnh đa góc chụp)
INSERT INTO DMHangHoa (MaHang, TenHang, MaKichThuoc, MaChatLieu, MaMau, MaNuocSX, SoLuong, GiaNhap, ThoiGianBaoHanh, Anh, GhiChu) VALUES
('TB01', N'Tủ Bếp Nhựa PVC Cánh Phủ Acrylic Bóng Gương An Cường Chữ I', 'KT03', 'CL05', 'M01', 'VN', 8, 13500000, N'60 tháng', 'tu_bep_01.jpg;tu_bep_01_angle.jpg;tu_bep_01_detail.jpg;tu_bep_01_inside.jpg', N'Thùng tủ nhựa PVC đặc 18mm chịu nước 100%, cánh phủ Acrylic noline bóng gương An Cường, bản lề giảm chấn inox 304.'),
('TB02', N'Tủ Bếp Inox 304 Khung Hộp Cánh Kính Cường Lực Viền Nhôm', 'KT04', 'CL03', 'M02', 'DE', 6, 24000000, N'60 tháng', 'tu_bep_02.jpg;tu_bep_02_angle.jpg;tu_bep_02_detail.jpg;tu_bep_02_inside.jpg', N'Khung inox hộp chuẩn SUS 304 dập chấn CNC cao cấp không mối hàn, cánh kính cường lực 4mm viền nhôm Anode tràn viền sang trọng.'),
('TB03', N'Tủ Bếp Gỗ Sồi Nga Tự Nhiên Sơn PU Màu Hạt Dẻ Bắc Âu', 'KT03', 'CL04', 'M03', 'NB', 6, 16500000, N'36 tháng', 'tu_bep_03.jpg;tu_bep_03_angle.jpg;tu_bep_03_detail.jpg;tu_bep_03_inside.jpg', N'100% gỗ Sồi Nga tự nhiên đã tẩm sấy công nghệ cao chống co ngót nứt nẻ, sơn lót PU 5 lớp giữ trọn vân gỗ uốn lượn.'),
('TB04', N'Tủ Bếp Gỗ MDF Lõi Xanh Chống Ẩm Phủ Melamine Chữ I', 'KT03', 'CL01', 'M04', 'VN', 12, 9800000, N'24 tháng', 'tu_bep_04.jpg;tu_bep_04_angle.jpg;tu_bep_04_detail.jpg;tu_bep_04_inside.jpg', N'Cốt gỗ MDF lõi xanh chống ẩm tiêu chuẩn E1 An Cường, bề mặt phủ Melamine chống trầy xước, giải pháp tối ưu cho chung cư.'),
('TB05', N'Tủ Bếp Nhựa PVC Sơn Men Bóng Ô Tô Công Nghệ Ánh Kim Chữ L', 'KT06', 'CL05', 'M05', 'VN', 7, 15000000, N'60 tháng', 'tu_bep_05.jpg;tu_bep_05_angle.jpg;tu_bep_05_detail.jpg;tu_bep_05_inside.jpg', N'Sơn men bóng ô tô cao cấp ánh kim độc quyền Xuyên Việt, line 2 màu xanh pastel dịu mắt, bo viền cạnh tinh tế chống ẩm tuyệt đối.'),
('TB06', N'Tủ Bếp Inox 304 Cánh Kính Vân Khói Hút Khử Mùi Kịch Trần', 'KT06', 'CL03', 'M04', 'DE', 5, 29000000, N'60 tháng', 'tu_bep_06.jpg;tu_bep_06_angle.jpg;tu_bep_06_detail.jpg;tu_bep_06_inside.jpg', N'Thiết kế kịch trần nhân đôi không gian chứa đồ, cánh kính màu khói phản quang sang trọng, kháng nước và chống cháy hoàn hảo.'),
('TB07', N'Tủ Bếp Gỗ Óc Chó (Walnut) Nhập Khẩu Bắc Mỹ Phong Cách Hoàng Gia', 'KT07', 'CL06', 'M06', 'VN', 3, 48000000, N'60 tháng', 'tu_bep_07.jpg;tu_bep_07_angle.jpg;tu_bep_07_detail.jpg;tu_bep_07_inside.jpg', N'Dòng gỗ thượng lưu màu nâu socola trầm ấm, hệ vân cuộn xoáy tự nhiên cuốn hút, hoàn thiện thủ công sơn Inchem 6 lớp đỉnh cao.'),
('TB08', N'Tủ Bếp Chữ L MDF Chống Ẩm Phủ Melamine Kết Hợp Acrylic', 'KT06', 'CL01', 'M03', 'VN', 10, 14500000, N'24 tháng', 'tu_bep_08.jpg;tu_bep_08_angle.jpg;tu_bep_08_detail.jpg;tu_bep_08_inside.jpg', N'Tủ dưới phủ Melamine chống xước chống va đập, tủ trên Acrylic bóng gương tạo độ tương phản thời thượng cho góc bếp chữ L.'),
('TB09', N'Tủ Bếp Acrylic Kịch Trần 2 Tầng Tối Đa Không Gian Chứa Đồ', 'KT04', 'CL02', 'M07', 'HQ', 8, 18500000, N'36 tháng', 'tu_bep_09.jpg;tu_bep_09_angle.jpg;tu_bep_09_detail.jpg;tu_bep_09_inside.jpg', N'Thiết kế 2 tầng kịch trần hiện đại, tay nắm âm nhôm chữ J tinh tế không vướng víu, cánh phủ Acrylic bóng sáng như gương.'),
('TB10', N'Tủ Bếp Nhựa PVC Phủ Laminate Vân Đá Chống Xước Cao Cấp', 'KT04', 'CL05', 'M02', 'VN', 9, 16500000, N'60 tháng', 'tu_bep_10.jpg;tu_bep_10_angle.jpg;tu_bep_10_detail.jpg;tu_bep_10_inside.jpg', N'Thùng nhựa PVC đặc chống nước tuyệt đối, cánh phủ Laminate vân đá sần chống trầy xước và chịu nhiệt vượt trội.'),
('TB11', N'Tủ Bếp Tân Cổ Điển Gỗ Tự Nhiên Sơn Men Trắng Sứ Nhập Khẩu', 'KT06', 'CL04', 'M01', 'IT', 4, 34000000, N'36 tháng', 'tu_bep_11.jpg;tu_bep_11_angle.jpg;tu_bep_11_detail.jpg;tu_bep_11_inside.jpg', N'Chạm khắc soi huỳnh viền chỉ tỉ mỉ phong cách quý tộc Châu Âu, mặt đá cẩm thạch Ý sang trọng, hệ phụ kiện giảm chấn cao cấp.'),
('TB12', N'Tủ Bếp Gỗ Xoan Đào Gia Lai Chọn Vân Vân Gỗ Đều Màu', 'KT02', 'CL07', 'M06', 'VN', 7, 12000000, N'24 tháng', 'tu_bep_12.jpg;tu_bep_12_angle.jpg;tu_bep_12_detail.jpg;tu_bep_12_inside.jpg', N'Gỗ Xoan Đào tự nhiên chọn lọc đanh chắc, chịu lực tốt, màu sắc cánh gián ấm cúng, hương thơm tự nhiên xua đuổi côn trùng.'),
('TB13', N'Tủ Bếp Inox Hệ Module Rời Cánh Hợp Kim Nhôm Cao Cấp', 'KT04', 'CL03', 'M02', 'NB', 4, 26500000, N'60 tháng', 'tu_bep_13.jpg;tu_bep_13_angle.jpg;tu_bep_13_detail.jpg;tu_bep_13_inside.jpg', N'Module inox độc lập công nghệ Nhật Bản tháo lắp linh hoạt, chống cong vênh và chống rỉ sét vĩnh cửu trong môi trường ẩm.'),
('TB14', N'Tủ Bếp Chữ U Acrylic Phối Bàn Đảo & Quầy Bar Mini', 'KT07', 'CL02', 'M08', 'IT', 4, 42000000, N'36 tháng', 'tu_bep_14.jpg;tu_bep_14_angle.jpg;tu_bep_14_detail.jpg;tu_bep_14_inside.jpg', N'Không gian nấu nướng chuẩn công thái học tam giác vàng, tone xanh Navy hoàng gia sang trọng, quầy bar thưởng rượu lý tưởng.'),
('TB15', N'Tủ Bếp Mini Studio 1m2 Tích Hợp Phụ Kiện Rút Thông Minh', 'KT01', 'CL01', 'M01', 'VN', 15, 7500000, N'12 tháng', 'tu_bep_15.jpg;tu_bep_15_angle.jpg;tu_bep_15_detail.jpg;tu_bep_15_inside.jpg', N'Tối ưu từng milimet cho căn hộ studio: giá dao thớt gia vị rút, thùng gạo âm tủ, ngăn chia thìa dĩa và chậu rửa mini tiện lợi.'),
('TB16', N'Tủ Bếp Gỗ Sồi Cánh Nan Chớp Thông Gió Chống Ẩm Mốc', 'KT03', 'CL04', 'M03', 'NB', 6, 16000000, N'24 tháng', 'tu_bep_16.jpg;tu_bep_16_angle.jpg;tu_bep_16_detail.jpg;tu_bep_16_inside.jpg', N'Thiết kế cánh nan chớp lưu thông không khí, giữ khoang gia vị và bát đĩa khô thoáng, chống ẩm mốc trong mùa nồm miền Bắc.'),
('TB17', N'Tủ Bếp Nhựa PVC Cánh Bo Viền Nghệ Thuật Phối Quầy Bar', 'KT07', 'CL05', 'M07', 'VN', 5, 22000000, N'60 tháng', 'tu_bep_17.jpg;tu_bep_17_angle.jpg;tu_bep_17_detail.jpg;tu_bep_17_inside.jpg', N'Tích hợp quầy bar gia đình và tủ rượu cánh kính đèn LED sang trọng, công nghệ bo góc nghệ thuật mềm mại và an toàn.'),
('TB18', N'Tủ Bếp Chữ L Inox Cánh Kính Cường Lực Sơn Nhiệt Ceramic', 'KT06', 'CL03', 'M04', 'DE', 6, 31000000, N'60 tháng', 'tu_bep_18.jpg;tu_bep_18_angle.jpg;tu_bep_18_detail.jpg;tu_bep_18_inside.jpg', N'Mặt kính cường lực hấp nhiệt men gốm ceramic chống xước và chịu sốc nhiệt lên tới 300 độ C, khung inox 304 chống mối mọt trọn đời.'),
('TB19', N'Tủ Bếp Sơn Men Màu Pastel Xanh Sage Mát Mẻ', 'KT03', 'CL01', 'M05', 'VN', 9, 11200000, N'24 tháng', 'tu_bep_19.jpg;tu_bep_19_angle.jpg;tu_bep_19_detail.jpg;tu_bep_19_inside.jpg', N'Gam màu xanh Sage pastel dịu mát, phong cách Scandinavian trẻ trung giúp căn bếp luôn tràn ngập năng lượng tươi mới.'),
('TB20', N'Tủ Bếp Biệt Thự Inox 304 Luxury Tích Hợp Đèn LED Cảm Ứng Bàn Đảo', 'KT07', 'CL03', 'M08', 'DE', 3, 55000000, N'60 tháng', 'tu_bep_20.jpg;tu_bep_20_angle.jpg;tu_bep_20_detail.jpg;tu_bep_20_inside.jpg', N'Dòng siêu phẩm dành cho biệt thự: bàn đảo 3m6, hệ thống ray trượt Blum điện tích hợp LED cảm ứng vẫy tay tự động cao cấp.');

-- 7.10. Bảng Hóa đơn nhập & Chi tiết hóa đơn nhập (Trigger tự cập nhật Thành tiền, Tổng tiền, Số lượng tồn, Giá nhập & Giá bán)
INSERT INTO HoaDonNhap (SoHDN, MaNV, NgayNhap, MaNCC, TongTien) VALUES
('HDN01', 'NV04', '2026-01-10', 'NCC01', 0),
('HDN02', 'NV04', '2026-02-15', 'NCC02', 0),
('HDN03', 'NV04', '2026-03-01', 'NCC03', 0),
('HDN04', 'NV04', '2026-03-20', 'NCC01', 0);

INSERT INTO ChiTietHoaDonNhap (SoHDN, MaHang, SoLuong, DonGia, GiamGia) VALUES
('HDN01', 'TB01', 3, 12000000, 0),
('HDN01', 'TB04', 5, 9500000, 5),
('HDN02', 'TB02', 2, 22000000, 2),
('HDN03', 'TB06', 4, 28000000, 0),
('HDN03', 'TB07', 2, 45000000, 3),
('HDN04', 'TB08', 6, 13500000, 5),
('HDN04', 'TB11', 3, 32000000, 2);

-- 7.11. Bảng Hóa đơn bán & Chi tiết hóa đơn bán (Trigger tự trừ Số lượng tồn, tính Thành tiền và Tổng tiền)
INSERT INTO HoaDonBan (SoHDB, MaNV, NgayBan, MaKhach, TongTien) VALUES
('HDB01', 'NV02', '2026-02-20', 'KH01', 0),
('HDB02', 'NV02', '2026-03-05', 'KH02', 0),
('HDB03', 'NV02', '2026-03-12', 'KH03', 0),
('HDB04', 'NV02', '2026-03-25', 'KH04', 0),
('HDB05', 'NV02', '2026-04-02', 'KH01', 0),
('HDB06', 'NV02', '2026-04-10', 'KH03', 0);

INSERT INTO ChiTietHoaDonBan (SoHDB, MaHang, SoLuong, GiamGia) VALUES
('HDB01', 'TB01', 1, 0),
('HDB01', 'TB04', 1, 5),
('HDB02', 'TB02', 1, 0),
('HDB03', 'TB01', 2, 10),
('HDB04', 'TB06', 1, 0),
('HDB04', 'TB08', 1, 5),
('HDB05', 'TB07', 1, 3),
('HDB06', 'TB11', 1, 0);

-- 7.12. Bảng Tài khoản người dùng (Tài khoản mẫu khớp với HUONG_DAN_DU_AN_BTL.md)
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, HoTen, Email, SoDienThoai, DiaChi, Quyen, MaKhach, MaNV, TrangThai, NgayTao) VALUES
('admin', '123456', N'Quản Trị Viên Hệ Thống', 'admin@kitchenlux.vn', '0912345678', N'Hà Nội', 'Admin', NULL, 'NV01', 1, GETDATE()),
('nv02', '123456', N'Trần Thị Bích (Nhân viên)', 'bich.tran@kitchenlux.vn', '0923456789', N'Hà Nội', 'Admin', NULL, 'NV02', 1, GETDATE()),
('khach01', '123456', N'Đỗ Minh Tuấn', 'tuan.do@gmail.com', '0901112233', N'Vinhomes Ocean Park, Gia Lâm', 'KhachHang', 'KH01', NULL, 1, GETDATE()),
('khach02', '123456', N'Nguyễn Thu Trang', 'trang.nguyen@gmail.com', '0902223344', N'EcoPark, Hưng Yên', 'KhachHang', 'KH02', NULL, 1, GETDATE());
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
