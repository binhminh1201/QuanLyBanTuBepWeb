# TỔNG HỢP TOÀN BỘ DỰ ÁN TỪ A ĐẾN Z (DÙNG ĐỂ TỰ LÀM BÁO CÁO)
**Đề tài (Số 47):** Xây dựng Website Quản Lý Bán Tủ Bếp  
**Thương hiệu website:** KITCHENLUX  
**Học phần:** Lập trình Web — ASP.NET Core MVC + Entity Framework Core + SQL Server 2022  
**Nhóm sinh viên:** Nhóm 5  

---

## MỤC LỤC TÀI LIỆU
1. **Tổng quan đề tài, Mô hình phát triển & Phạm vi nghiệp vụ**
2. **Cơ sở dữ liệu: Danh sách 14 bảng, Quan hệ ERD, Khóa chính, Khóa ngoại, Triggers & 4 Stored Procedures**
3. **Kiến trúc mã nguồn C# (Controllers, Actions, ViewModels, Helpers)**
4. **Các kỹ thuật lập trình môn học đã áp dụng (AJAX, Session, Validation Regex, Cookie Auth, ViewComponent, Web API, i18n)**
5. **Cơ chế Bảo mật & Bảng băm mật khẩu (Password Hashing PBKDF2)**
6. **Danh mục tài khoản mẫu & Hướng dẫn khởi chạy**
7. **Bảng kịch bản kiểm thử (Test Cases Cheat Sheet)**
8. **Danh mục hình ảnh chụp giao diện thực tế (Report Screenshots)**
9. **Đánh giá kết quả đạt được, Hạn chế & Hướng phát triển (Viết phần Kết luận)**

---

## 1. TỔNG QUAN ĐỀ TÀI, MÔ HÌNH PHÁT TRIỂN & PHẠM VI NGHIỆP VỤ

### 1.1. Bối cảnh & Lý do chọn đề tài
- Ngành kinh doanh tủ bếp và nội thất phòng bếp mang giá trị kinh tế cao, kích thước và kết cấu phức tạp (kết hợp thùng tủ, cánh tủ, phụ kiện ray trượt bản lề, kính cường lực, đá ốp).
- Quản lý truyền thống bằng sổ sách hoặc file Excel dễ nhầm lẫn số lượng tồn kho, thất lạc thông tin khách cần khảo sát đo đạc thực tế, chậm trễ trong việc tổng hợp doanh thu theo quý.
- Xây dựng website thương mại điện tử **KITCHENLUX** giúp số hóa toàn diện quy trình tiếp thị sản phẩm, lọc tìm kiếm đa tiêu chí, đặt hàng khảo sát online và tự động hóa hệ thống báo cáo quản trị.

### 1.2. Mô hình phát triển phần mềm: Mô hình Thác nước (Waterfall Model)
Dự án áp dụng **Mô hình Thác nước (Waterfall Model)** với quy trình phát triển tuyến tính qua 5 giai đoạn tuần tự:
1. **Khảo sát & Thu thập yêu cầu (Requirements):** Xác định phạm vi nghiệp vụ Đề tài 47 (tìm kiếm HĐB đa tiêu chí, 4 báo cáo thống kê chuyên biệt, quy trình khảo sát lắp đặt tại nhà, giỏ hàng trực tuyến).
2. **Phân tích & Thiết kế hệ thống (Analysis & Design):**
   - Thiết kế sơ đồ Use Case cho 2 tác nhân chính (Khách hàng và Quản trị viên).
   - Thiết kế Cơ sở dữ liệu quan hệ (ERD) chuẩn hóa 14 bảng, xác lập đầy đủ khóa chính, khóa ngoại, bảng liên kết n-n.
   - Thiết kế Wireframe/Mockup giao diện người dùng theo chuẩn phong cách nội thất kiến trúc hiện đại.
3. **Cài đặt & Lập trình (Implementation):**
   - Backend: C# trên nền tảng ASP.NET Core 8.0/10.0 MVC, kết nối CSDL qua Entity Framework Core (LINQ to Entities).
   - Database: SQL Server 2022 cài đặt 14 bảng, 2 triggers tự động hóa và 4 stored procedures nghiệp vụ.
   - Frontend: Razor View Engine kết hợp Bootstrap 5, Bootstrap Icons, JavaScript và jQuery AJAX.
4. **Kiểm thử hệ thống (Testing):**
   - Thực hiện kiểm thử hộp đen (Black-box testing) trên 15 kịch bản kiểm thử (Test Cases) trọng yếu.
   - Kiểm tra ràng buộc khóa ngoại (Foreign Key integrity), bắt lỗi validation dữ liệu đầu vào và kiểm tra phân quyền bảo mật.
5. **Triển khai & Vận hành (Deployment & Maintenance):**
   - Triển khai chạy trên máy chủ nội bộ Kestrel/IIS Express, kiểm thử khả năng đáp ứng trên các trình duyệt hiện đại (Chrome, Edge).

*Lý do lựa chọn Waterfall:* Đề tài môn học có yêu cầu kỹ thuật và tiêu chí đánh giá cố định rõ ràng ngay từ đầu theo phiếu giao đề tài (Đề tài 47). Quy trình thác nước giúp nhóm kiểm soát chặt chẽ từng mốc tiến độ (milestone), hoàn thiện đầy đủ hồ sơ thiết kế trước khi lập trình.

### 1.3. 4 Luồng nghiệp vụ cốt lõi
1. **Showroom trực tuyến:** Khách hàng xem danh mục 20 mẫu tủ bếp (Acrylic, Inox 304 cánh kính, Gỗ Sồi, Nhựa Picomat, Gỗ MDF). Lọc kết hợp đa tiêu chí qua AJAX không reload trang. Xem album 4 góc ảnh thực tế của từng sản phẩm.
2. **Bán hàng & Đặt hàng khảo sát:** Giỏ hàng lưu trữ bằng Session. Đặt hàng với form thông tin nhận hàng (kiểm tra Số điện thoại bằng Regex: bắt đầu bằng 0, gồm 10 hoặc 11 chữ số). Hệ thống tự tạo Hóa đơn bán, trừ tồn kho trong CSDL.
3. **Quản trị nhập kho & Tính giá bán tự động:** Quản lý hóa đơn nhập từ các nhà cung cấp uy tín (An Cường, Picomat, Hafele). Trigger trong CSDL tự động tính giá bán đề xuất $= 110\% \times \text{Giá nhập}$.
4. **Báo cáo thống kê & Tìm kiếm đa tiêu chí (Đề tài 47):**
   - Tìm kiếm hóa đơn bán đa tiêu chí (kết hợp mã hàng, khoảng ngày bán, khoảng tổng tiền - YC5).
   - Báo cáo Top 3 sản phẩm bán chạy nhất theo Quý (YC6).
   - Báo cáo chi tiết hóa đơn nhập hàng phân bổ theo từng nhân viên phụ trách (YC7).
   - Báo cáo 5 hóa đơn bán hàng có giá trị nhỏ nhất trong Quý (YC8).
   - Báo cáo danh sách khách hàng và doanh số bán theo Tháng (YC9).

---

## 2. CƠ SỞ DỮ LIỆU: 14 BẢNG, QUAN HỆ ERD, KHÓA CHÍNH, KHÓA NGOẠI, TRIGGERS & PROCEDURES

Tên CSDL: **`QuanLyBanTuBep`** (Chạy từ file script `QuanLyBanTuBep.sql`).

### 2.1. Phân loại 14 bảng

```
                         ┌───────────────────────────┐
                         │   CSDL QUANLYBANTUBEP     │
                         └─────────────┬─────────────┘
                                       │
        ┌──────────────────────────────┼──────────────────────────────┐
        ▼                              ▼                              ▼
 1. NHÓM DANH MỤC              2. NHÓM ĐỐI TÁC - NHÂN SỰ        3. NHÓM BÁN - NHẬP HÀNG
 - KichThuoc                   - CongViec                      - HoaDonBan
 - ChatLieu                    - NhanVien                      - ChiTietHoaDonBan
 - MauSac                      - KhachHang                     - HoaDonNhap
 - NuocSanXuat                 - NhaCungCap                    - ChiTietHoaDonNhap
 - DMHangHoa (Bảng trung tâm)  - TaiKhoan (Bảo mật PBKDF2)
```

### 2.2. Chi tiết các bảng quan trọng nhất

#### Bảng `DMHangHoa` (Sản phẩm Tủ bếp - Bảng trung tâm):
* `MaHang` (NVARCHAR(20), PK): Mã sản phẩm (TB01 $\rightarrow$ TB20).
* `TenHang` (NVARCHAR(150), NOT NULL): Tên thương mại mẫu tủ bếp.
* `MaKichThuoc` (NVARCHAR(20), FK): Nối sang `KichThuoc(MaKichThuoc)` (Dài 1.2m, 2.0m, Chữ L, Chữ U,...).
* `MaChatLieu` (NVARCHAR(20), FK): Nối sang `ChatLieu(MaChatLieu)` (Acrylic, Inox cánh kính, Gỗ Sồi, Picomat, MDF).
* `MaMau` (NVARCHAR(20), FK): Nối sang `MauSac(MaMau)` (Trắng sứ, Xám ghi, Vân gỗ, Đen mờ, Xanh pastel,...).
* `MaNuocSX` (NVARCHAR(20), FK): Nối sang `NuocSanXuat(MaNuocSX)` (Việt Nam, Đức, Nhật Bản, Hàn Quốc, Ý,...).
* `SoLuong` (INT, DEFAULT 0): Số lượng tồn kho.
* `GiaNhap` (DECIMAL(18,2)): Giá vốn nhập từ nhà cung cấp.
* `DonGiaBan` (DECIMAL(18,2)): Giá bán lẻ niêm yết (Trigger tự động tính $= 110\% \times GiaNhap$).
* `ThoiGianBaoHanh` (NVARCHAR(50)): Thời gian bảo hành (24 tháng, 36 tháng, 60 tháng).
* `Anh` (NVARCHAR(255)): Chuỗi file ảnh phân tách dấu chấm phẩy `;` hoặc tên tệp ảnh upload từ Admin.
* `GhiChu` (NVARCHAR(500)): Thông số phụ kiện hoặc nội dung CKEditor.

#### Bảng `CongViec` & `NhanVien` (Quan hệ Khóa Ngoại trong ERD):
* `CongViec`: `MaCV` (NVARCHAR(20), PK), `TenCV` (NVARCHAR(50), NOT NULL), `MucLuong` (DECIMAL).
* `NhanVien`: `MaNV` (NVARCHAR(20), PK), `TenNV`, `GioiTinh`, `NgaySinh`, `DienThoai`, `DiaChi`, `MaCV` (NVARCHAR(20), FK).
* **Ràng buộc khóa ngoại chính thức trong SQL:**
  ```sql
  ALTER TABLE NhanVien
  ADD CONSTRAINT FK_NhanVien_CongViec 
  FOREIGN KEY (MaCV) REFERENCES CongViec(MaCV)
  ON UPDATE CASCADE ON DELETE SET NULL;
  ```
  *Ý nghĩa nghiệp vụ:* Bảng `CongViec` lưu danh mục chức danh (Kỹ sư thiết kế, Thợ mộc, Nhân viên kinh doanh, Quản lý). Bảng `NhanVien` lưu nhân sự và liên kết `MaCV` để xác định vị trí công tác. Do đó việc nối `CongViec ||--o{ NhanVien` trong sơ đồ ERD là **hoàn toàn chính xác 100%**.

#### Bảng `HoaDonBan` & `ChiTietHoaDonBan`:
* `HoaDonBan`: `SoHDB` (PK), `MaNV` (FK $\rightarrow$ `NhanVien`), `NgayBan` (DATE), `MaKhach` (FK $\rightarrow$ `KhachHang`), `TongTien` (DECIMAL).
* `ChiTietHoaDonBan`: `SoHDB` (FK) + `MaHang` (FK) $\rightarrow$ Khóa chính kép. `SoLuong` (> 0), `GiamGia` (%), `ThanhTien` (DECIMAL).

#### Bảng `HoaDonNhap` & `ChiTietHoaDonNhap`:
* `HoaDonNhap`: `SoHDN` (PK), `MaNV` (FK $\rightarrow$ `NhanVien`), `NgayNhap`, `MaNCC` (FK $\rightarrow$ `NhaCungCap`), `TongTien`.
* `ChiTietHoaDonNhap`: `SoHDN` (FK) + `MaHang` (FK) $\rightarrow$ Khóa chính kép. `SoLuong`, `DonGia`, `GiamGia`, `ThanhTien`.

#### Bảng `TaiKhoan` (Xác thực, Bảo mật & Phân quyền):
* `TenDangNhap` (NVARCHAR(50), PK): Định danh duy nhất.
* `MatKhau` (NVARCHAR(255), NOT NULL): **Được mã hóa băm an toàn một chiều (PBKDF2 SHA-256 kèm 128-bit Salt)** qua `PasswordHasher<TaiKhoan>`, độ dài 84 ký tự.
* `HoTen` (NVARCHAR(100), NOT NULL): Họ và tên đầy đủ.
* `SoDienThoai` (NVARCHAR(20)): **Bắt buộc khi đăng ký**. Kiểm tra định dạng bằng Regex `^0\d{9,10}$` (cho phép số di động 10 chữ số hoặc số cố định 11 chữ số có mã vùng, bắt đầu bằng số 0).
* `Email` (NVARCHAR(100), NULL): Tùy chọn (không bắt buộc).
* `DiaChi` (NVARCHAR(200), NULL): Địa chỉ lắp đặt tủ bếp.
* `Quyen` (NVARCHAR(20)): `'Admin'` hoặc `'KhachHang'`.
* `MaKhach` (FK), `MaNV` (FK): Tự động liên kết hồ sơ khách hàng hoặc nhân viên.

### 2.3. Triggers & Stored Procedures đặc thù của Đề tài 47

#### Trigger:
1. `trg_CapNhatGiaBanVaTongTienNhap` (bảng `ChiTietHoaDonNhap`):
   - Tự tính `ThanhTien = SoLuong * DonGia * (1 - GiamGia / 100)`.
   - Tự động cộng tồn kho: `DMHangHoa.SoLuong += ChiTiet.SoLuong`.
   - Tự động cập nhật `GiaNhap` và **áp dụng giá bán đề xuất: `DonGiaBan = DonGiaNhap * 1.10`**.
   - Cập nhật tổng tiền bảng `HoaDonNhap`.
2. `trg_ChiTietHoaDonBan_InsertUpdate` (bảng `ChiTietHoaDonBan`):
   - Tự động trừ tồn kho: `DMHangHoa.SoLuong -= ChiTiet.SoLuong`.
   - Tự tính thành tiền và cập nhật `HoaDonBan.TongTien`.

#### Bộ 4 Stored Procedures báo cáo:
1. `sp_BaoCaoTop3SanPhamTheoQuy(@Nam, @Quy)`: **Yêu cầu 6** — Top 3 sản phẩm bán nhiều nhất trong quý theo công thức tháng `(Quy - 1) * 3 + 1` đến `Quy * 3`.
2. `sp_BaoCaoHoaDonNhapTheoNV(@MaNV)`: **Yêu cầu 7** — Thống kê chi tiết các hóa đơn do một nhân viên chỉ định nhập hàng.
3. `sp_BaoCaoTop5HDBanNhoNhatTheoQuy(@Nam, @Quy)`: **Yêu cầu 8** — 5 hóa đơn bán có giá trị nhỏ nhất trong quý (`ORDER BY TongTien ASC`).
4. `sp_BaoCaoKhachHangTheoThang(@Nam, @Thang)`: **Yêu cầu 9** — Danh sách khách hàng và tổng tiền mua hàng theo tháng (`ORDER BY TongTienMua DESC`).

---

## 3. KIẾN TRÚC MÃ NGUỒN C# & PHÂN CHIA CONTROLLERS

### 3.1. Phân hệ Khách hàng (Root Area)

| Controller | Action | Nghiệp vụ & Kỹ thuật |
| :--- | :--- | :--- |
| `HomeController` | `Index()` | Hiển thị sản phẩm nổi bật, 4 khối cam kết có liên kết tới tab dịch vụ. Giao diện kiến trúc cao cấp. |
| | `About()` | Giới thiệu thương hiệu KITCHENLUX, xưởng sản xuất, đối tác vật liệu An Cường, Picomat. |
| | `Contact()` | Form gửi yêu cầu báo giá khảo sát, bản đồ showroom, hotline kỹ thuật. |
| | `Policy(string? tab)` | Trang chính sách 4 tab (Bảo hành, Khảo sát, Thanh toán, Bảo mật). Cập nhật URL `?tab=...` qua JavaScript history. |
| `ProductController` | `Index(...)` | Nạp danh mục sản phẩm kết hợp ViewComponent sidebar và PartialView. |
| | `FilterProducts(...)` | **Action lõi AJAX**: Nhận keyword, chất liệu, màu, kích thước, khoảng giá $\rightarrow$ lọc LINQ $\rightarrow$ trả về `_ProductListPartial` (không reload trang). |
| | `Details(string id)` | Xem chi tiết: hiển thị album ảnh đa góc, bảng thông số kỹ thuật, gợi ý sản phẩm cùng chất liệu. |
| `CartController` | `Index()` | Xem giỏ hàng từ Session. |
| | `AddToCart(string id)` | **AJAX POST**: Thêm sản phẩm vào Session giỏ hàng, cập nhật badge số lượng và hiện Toast thông báo. |
| | `UpdateCart(...)` | Tăng/giảm số lượng sản phẩm trong giỏ. |
| | `RemoveFromCart(string id)` | Xóa sản phẩm khỏi giỏ. |
| | `Checkout()` | Đặt hàng: Validate 2 lớp (Họ tên, SĐT bắt buộc regex `^0\d{9,10}$`). Lưu `HoaDonBan`, trừ tồn kho CSDL và xóa trắng giỏ hàng. |
| | `OrderSuccess(string id)` | Trang cảm ơn và hiển thị mã đơn hàng vừa tạo. |
| `AccountController` | `Register(...)` | Đăng ký: SĐT bắt buộc regex 10-11 số, mật khẩu tự động băm qua PBKDF2 SHA-256. |
| | `Login(...)` | Đăng nhập qua Cookie Authentication, đối soát chuỗi băm `VerifyHashedPassword`, tự động nâng cấp mật khẩu cũ. |
| | `Logout()` | Đăng xuất, hủy cookie phiên làm việc. |
| | `Orders()` | Xem lịch sử đơn hàng của chính khách hàng đã đăng nhập. |
| | `AccessDenied()` | Trang hiển thị khi khách hàng cố truy cập URL Admin (Lỗi 403 Forbidden). |

### 3.2. Phân hệ Quản trị viên (`Areas/Admin`)

| Controller | Action | Nghiệp vụ & Kỹ thuật |
| :--- | :--- | :--- |
| `Admin/HomeController` | `Index()` | Dashboard: Thống kê tổng số SP, tổng doanh số, số HĐ bán, số HĐ nhập. |
| `Admin/DMHangHoaController` | `Index()` | Bảng danh sách quản lý tất cả mẫu tủ bếp. |
| | `Create(...)` | Form thêm mới: Dropdown danh mục, nhập giá, **Upload ảnh qua `IFormFile` kèm Live Preview** lưu vào `wwwroot/images/products/`, soạn mô tả bằng CKEditor. |
| | `Edit(string id)` | Sửa thông số tủ bếp, xem ảnh hiện tại và chọn thay ảnh mới với Live Preview. |
| | `Delete(string id)` | **Bảo vệ toàn vẹn khóa ngoại**: Kiểm tra `.Any()` trong `ChiTietHoaDonBan` và `ChiTietHoaDonNhap`. Nếu sản phẩm đã phát sinh hóa đơn $\rightarrow$ Chặn xóa và hiển thị thông báo lỗi đỏ. |
| `Admin/HoaDonBanController` | `Index(...)` | **Yêu cầu 5 của Đề 47**: Tìm kiếm hóa đơn bán đa tiêu chí (kết hợp mã hàng hóa có trong đơn, khoảng ngày bán `tuNgay` - `denNgay`, khoảng tiền `tongTienTu` - `tongTienDen`). |
| | `Details(string id)` | Xem chi tiết danh sách các mặt hàng trong hóa đơn bán. |
| `Admin/BaoCaoController` | `Index()` | Menu điều hướng 4 báo cáo của đề tài. |
| | `Top3SanPhamTheoQuy` | **Yêu cầu 6**: Báo cáo Top 3 sản phẩm bán chạy nhất trong quý. |
| | `HoaDonNhapTheoNV` | **Yêu cầu 7**: Dropdown chọn nhân viên $\rightarrow$ Liệt kê tất cả hóa đơn nhập hàng của nhân viên đó kèm tổng kinh phí. |
| | `Top5HDBanNhoNhat` | **Yêu cầu 8**: Báo cáo 5 hóa đơn bán có giá trị nhỏ nhất trong quý. |
| | `KhachHangTheoThang` | **Yêu cầu 9**: Báo cáo danh sách khách hàng và doanh thu theo tháng. |

### 3.3. Dịch vụ Web API RESTful
* File: `Controllers/Api/TuBepApiController.cs`.
* Endpoint `GET /api/tubep`: Trả về danh sách tất cả mẫu tủ bếp dưới dạng JSON.
* Endpoint `GET /api/tubep/{id}`: Trả về chi tiết tủ bếp theo ID (hoặc mã 404 nếu không tìm thấy).

---

## 4. CÁC KỸ THUẬT LẬP TRÌNH MÔN HỌC ĐÃ ÁP DỤNG

1. **Bộ 3 tương tác AJAX (Không reload trang):**
   - Lọc đa tiêu chí theo Chất liệu, Màu sắc, Kích thước, Xuất xứ và Khoảng giá.
   - Tìm kiếm từ khóa theo tên hoặc mã tủ bếp.
   - Phân trang động (Paging) bằng AJAX kết hợp jQuery và `PartialView("_ProductListPartial")`.
2. **Quản lý trạng thái (State Management):**
   - `ISession` kết hợp `System.Text.Json` qua helper `SessionExtensions.cs` để lưu giỏ hàng `List<CartItem>`.
   - `CookieAuthenticationDefaults` lưu phiên làm việc người dùng và phân quyền theo Role.
3. **Kiểm tra tính hợp lệ dữ liệu (Validation 2 lớp & Regex SĐT chuẩn):**
   - Phía Client: jQuery Validation (`jquery.validate.unobtrusive.min.js`).
   - Phía Server: Data Annotations (`[Required]`, `[Range]`, `[StringLength]`) kết hợp `ModelState.IsValid`.
   - **Thống nhất Regex Số điện thoại:** Biểu thức `[RegularExpression(@"^0\d{9,10}$")]` yêu cầu bắt đầu bằng chữ số 0, cho phép độ dài **10 chữ số** (số di động các mạng Viettel, Vina, Mobi) hoặc **11 chữ số** (số điện thoại bàn cố định có mã vùng tỉnh/thành phố). Thông báo lỗi chuẩn: *"Số điện thoại phải bắt đầu bằng số 0 và gồm 10 đến 11 chữ số"*.
4. **Đóng gói giao diện với `ViewComponent`:**
   - Lớp: `ProductFilterSidebarViewComponent.cs` trong thư mục `ViewComponents/`.
   - View: `Views/Shared/Components/ProductFilterSidebar/Default.cshtml`.
   - Tự động nạp 4 danh mục phụ trợ độc lập, loại bỏ việc truyền thủ công qua `ViewBag`.
5. **Upload file hình ảnh thực tế (Quyền Admin):**
   - Sử dụng `IFormFile` nhận file tải lên từ form trong `DMHangHoaController`, kiểm tra định dạng ảnh (`.jpg`, `.jpeg`, `.png`, `.webp`, `.svg`) và dung lượng tối đa 5MB.
   - Lưu file vật lý vào `wwwroot/images/products/` bằng `FileStream`, lưu tên tệp vào DB.
   - Giao diện Admin trang bị khung xem trước ảnh trực tiếp (**Live Image Preview**) ngay khi chọn tệp.
6. **Cơ chế Quốc tế hóa (i18n - Internationalization):**
   - ASP.NET Core cung cấp thư viện `Microsoft.AspNetCore.Localization` và interface `IStringLocalizer<T>`.
   - Cấu hình qua Middleware `RequestLocalizationOptions` trong `Program.cs` hỗ trợ song ngữ Tiếng Việt (`vi-VN`) làm mặc định và Tiếng Anh (`en-US`).
   - Từ điển dịch thuật được quản lý bằng các tệp tài nguyên XML (`.resx`): `Resources/SharedResource.vi.resx` và `Resources/SharedResource.en.resx`.
   - Cơ chế phát hiện văn hóa đa tầng (Culture Providers) ưu tiên qua: Query string (`?culture=en-US`), Cookie văn hóa (`.AspNetCore.Culture`), và Header `Accept-Language` của trình duyệt.

---

## 5. BẢO MẬT HỆ THỐNG & BẢNG BĂM MẬT KHẨU (PASSWORD HASHING)

Hệ thống được thiết kế với 5 tầng bảo mật:
1. **Bảo mật mật khẩu bằng Bảng băm một chiều (Password Hashing):**
   - Hệ thống áp dụng lớp chuẩn công nghiệp `Microsoft.AspNetCore.Identity.PasswordHasher<TaiKhoan>`.
   - Thuật toán lõi: **PBKDF2 với HMAC-SHA256, 128-bit Salt và 10.000+ vòng lặp**.
   - Mật khẩu lưu trong cột `MatKhau` là chuỗi băm 84 ký tự bắt đầu bằng tiền tố định danh v3 `AQAAAA...`. Kẻ xấu dù chiếm được CSDL cũng không thể giải mã ngược lại mật khẩu gốc.
   - Cơ chế tự động di trú: Ứng dụng tự động phát hiện các tài khoản mẫu cũ lưu dạng văn bản thô để băm lại ngay khi khởi động hoặc khi người dùng đăng nhập lần đầu.
2. **Chống tấn công CSRF (Cross-Site Request Forgery):**
   - Mọi form gửi dữ liệu (Đăng ký, Đăng nhập, Đặt hàng, Thêm/Sửa/Xóa Admin) đều được gắn thẻ `@Html.AntiForgeryToken()` sinh token mã hóa kép (Cookie + Hidden Field). Controller kiểm duyệt nghiêm ngặt qua thuộc tính `[ValidateAntiForgeryToken]`.
3. **Chống tấn công SQL Injection:**
   - 100% các truy vấn dữ liệu từ Controller đều sử dụng **Entity Framework Core (LINQ to Entities)**. EF Core tự động tham số hóa (parameterize) toàn bộ giá trị biến truyền vào lệnh SQL, vô hiệu hóa hoàn toàn kỹ thuật tiêm mã độc.
4. **Chống tấn công XSS (Cross-Site Scripting):**
   - Razor View Engine của ASP.NET Core mặc định tự động mã hóa ký tự HTML (`HTML Encoding`) trước khi render ra trình duyệt, ngăn chặn kẻ xấu chèn mã JavaScript độc hại vào thông tin sản phẩm hay họ tên khách hàng.
5. **Kiểm soát truy cập & Phân quyền theo vai trò (Role-Based Authorization):**
   - Sử dụng `CookieAuthenticationDefaults` tạo vé xác thực danh tính mã hóa trong HTTP-only Cookie.
   - Toàn bộ phân hệ Quản trị (`Areas/Admin`) được bảo vệ bởi bộ lọc `[Authorize(Roles = "Admin")]`. Khách hàng cố tình truy cập trái phép sẽ lập tức bị chặn và điều hướng về trang lỗi 403 `/Account/AccessDenied`.

---

## 6. DANH MỤC TÀI KHOẢN MẪU & KHỞI CHẠY DỰ ÁN

### 6.1. Bảng tài khoản kiểm thử

| Loại tài khoản | Tên đăng nhập | Mật khẩu gốc | Dạng lưu trữ trong CSDL | Quyền hạn (Role) | Chức năng chính |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin` | `123456` | Chuỗi băm PBKDF2 (`AQAAAA...`) | `Admin` | Truy cập `/Admin`: Dashboard, CRUD sản phẩm, 4 báo cáo thống kê, quản lý đơn hàng. |
| **Nhân viên 2** | `nv02` | `123456` | Chuỗi băm PBKDF2 (`AQAAAA...`) | `Admin` | Nhân viên bán hàng có quyền quản trị. |
| **Khách hàng 1** | `khach01` | `123456` | Chuỗi băm PBKDF2 (`AQAAAA...`) | `KhachHang` | Xem sản phẩm, lọc AJAX, giỏ hàng, đặt hàng, xem lịch sử đơn hàng cá nhân. |
| **Khách hàng 2** | `khach02` | `123456` | Chuỗi băm PBKDF2 (`AQAAAA...`) | `KhachHang` | Tài khoản khách hàng thành viên. |

### 6.2. Cách khởi chạy dự án
1. Mở SQL Server Management Studio (SSMS), mở file script `QuanLyBanTuBep.sql` và nhấn **F5** để tạo CSDL và nạp dữ liệu mẫu 20 mẫu tủ bếp.
2. Kiểm tra chuỗi kết nối `DefaultConnection` trong file `appsettings.json`.
3. Mở file `QuanLyBanTuBepWeb.csproj` bằng Visual Studio và nhấn **F5** (hoặc mở Terminal gõ `cd QuanLyBanTuBepWeb` $\rightarrow$ `dotnet run`).
4. Truy cập website tại: `http://localhost:5000`.

---

## 7. BẢNG KỊCH BẢN KIỂM THỬ (TEST CASES CHEAT SHEET)

| ID | Chức năng test | Dữ liệu đầu vào & Ràng buộc | Kết quả kỳ vọng | Kết quả thực tế | Trạng thái | Đề xuất & Quá trình Fix lỗi |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: | :--- |
| **TC01** | Lọc SP theo chất liệu qua AJAX | Chọn chất liệu: `CL02` (Acrylic) | Khung danh sách nạp các mẫu tủ Acrylic, không reload trang | Danh sách cập nhật mượt mà qua PartialView | **PASS** | Xây dựng Action FilterProducts trả về PartialView |
| **TC02** | Lọc SP theo khoảng giá qua AJAX | Chọn radio: "Dưới 10 triệu" | Chỉ hiển thị các tủ bếp có giá bán $\le 10$ triệu | Hiển thị chính xác sản phẩm TB04 (9.8tr) và TB15 (7.5tr) | **PASS** | Tách chuỗi khoảng giá bằng hàm Split('-') trong LINQ |
| **TC03** | Tìm kiếm từ khóa theo tên tủ bếp | Nhập từ khóa: `"Inox"` và bấm Enter | Hiển thị tất cả các mẫu tủ bếp có tên chứa chữ Inox | Hiển thị đúng 5 mẫu tủ Inox (TB02, TB06, TB13, TB18, TB20) | **PASS** | Bắt sự kiện Keypress Enter trong jQuery |
| **TC04** | Phân trang dữ liệu bằng AJAX | Bấm chuyển sang trang số 2 | Nạp 6 sản phẩm tiếp theo, tự động cuộn lên đầu danh sách | Nạp chính xác 6 sản phẩm kế tiếp, URL giữ nguyên | **PASS** | Áp dụng LINQ Skip((page-1)*6).Take(6) và hàm scrollTop |
| **TC05** | Thêm sản phẩm vào giỏ qua AJAX | Bấm nút "Chọn mua" tại sản phẩm `TB01` | Huy hiệu giỏ hàng nhảy từ 0 lên 1, hiện Toast thông báo | Badge giỏ hàng cập nhật ngay lập tức, Toast hiện xanh | **PASS** | Tuần tự hóa giỏ hàng JSON lưu vào ISession |
| **TC06** | Cập nhật số lượng trong giỏ hàng | Bấm nút [+] tăng số lượng TB01 lên 2 | Số lượng = 2, tổng tiền đơn hàng nhân đôi | Số lượng cập nhật chính xác, thành tiền nhân đôi | **PASS** | Viết Action UpdateCart cập nhật lại Session |
| **TC07** | Validate để trống SĐT khi Đặt hàng | Bỏ trống Họ tên và SĐT, bấm "Đặt hàng" | Báo lỗi đỏ: "Số điện thoại không được để trống" | Dòng chữ đỏ cảnh báo lỗi xuất hiện ngay dưới ô input | **PASS** | Bổ sung `[Required(ErrorMessage="...")]` vào ViewModel |
| **TC08** | Validate sai định dạng SĐT | Nhập SĐT: `"123456"` (thiếu số 0, không đủ 10 số) | Báo lỗi: "Số điện thoại phải bắt đầu bằng số 0 và gồm 10 đến 11 chữ số" | Báo lỗi chính xác theo biểu thức chính quy | **PASS** | Bổ sung `[RegularExpression(@"^0\d{9,10}$")]` |
| **TC09** | Đặt hàng thành công & Trừ tồn kho | Nhập đầy đủ thông tin nhận hàng hợp lệ | Sinh mã HDB mới trong DB, trừ tồn kho, giỏ hàng rỗng | Tạo hóa đơn thành công, điều hướng sang OrderSuccess | **PASS** | Mở Transaction lưu HoaDonBan và trừ SoLuong trong CSDL |
| **TC10** | Đăng ký thành viên không nhập Email | Nhập Họ tên, SĐT, User, Pass; để trống Email | Đăng ký thành công, tài khoản lưu với Email = NULL | Đăng ký thành công, tự động liên kết mã khách hàng mới | **PASS** | Chuyển trường Email trong ViewModel sang kiểu nullable `string?` |
| **TC11** | Chặn truy cập trái phép trang Admin | Tài khoản khách hàng gõ URL `/Admin/DMHangHoa` | Bị chặn truy cập, chuyển hướng về trang lỗi 403 | Hệ thống chuyển hướng chính xác về `/Account/AccessDenied` | **PASS** | Gắn thuộc tính `[Authorize(Roles = "Admin")]` vào Admin Area |
| **TC12** | Thêm tủ bếp mới kèm Upload ảnh | Nhập thông tin SP, chọn file ảnh `.jpg` | Sản phẩm lưu vào DB, file ảnh lưu `wwwroot/images/products` | Sản phẩm mới xuất hiện trên danh sách kèm ảnh hiển thị | **PASS** | Xử lý `IFormFile` kiểm tra định dạng và lưu file qua `FileStream` |
| **TC13** | Xóa SP có ràng buộc khóa ngoại | Bấm nút Xóa sản phẩm `TB01` (đã có trong hóa đơn) | Từ chối xóa, hiển thị cảnh báo lỗi dữ liệu toàn vẹn | Báo lỗi: "Không thể xoá vì sản phẩm đã có trong hóa đơn!" | **PASS** | Kiểm tra `.Any()` trên bảng con trước khi xóa |
| **TC14** | Báo cáo Top 3 SP theo Quý (YC6) | Chọn Năm: 2026, Quý: 1 | Trả về 3 sản phẩm bán chạy nhất quý 1/2026 | Hiển thị chính xác 3 sản phẩm TB01, TB04, TB02 | **PASS** | Gọi thực thi thủ tục `sp_BaoCaoTop3SanPhamTheoQuy` |
| **TC15** | Báo cáo HĐ Nhập theo NV (YC7) | Chọn nhân viên: `NV04 - Phạm Thu Hà` | Liệt kê tất cả hóa đơn nhập hàng do NV04 thực hiện | Hiển thị chính xác 4 hóa đơn HDN01-HDN04 của NV04 | **PASS** | Viết Action `HoaDonNhapTheoNV` và View hiển thị chuyên biệt |

---

## 8. DANH MỤC HÌNH ẢNH GIAO DIỆN THỰC TẾ (SCREENSHOTS)

Toàn bộ ảnh chụp màn hình độ nét cao đã được chụp trực tiếp từ ứng dụng thực tế và lưu tại thư mục `ReportScreenshots/`:

| STT | Tên file ảnh | Vị trí chèn trong Báo cáo | Mô tả nội dung giao diện |
| :---: | :--- | :--- | :--- |
| 1 | `Hinh4.1_TrangChu.png` | **Mục 3.1 & Wireframe 2.4** | Trang chủ Showroom KITCHENLUX (Hero banner kiến trúc, bộ lọc nhanh chất liệu, Top sản phẩm bán chạy, 4 cam kết dịch vụ). |
| 2 | `Hinh4.2_BoLocSanPham.png` | **Mục 3.2.1** | Danh mục sản phẩm: Sidebar lọc đa tiêu chí (Chất liệu, Màu sắc, Kích thước, Xuất xứ, Khoảng giá) và ô tìm kiếm AJAX. |
| 3 | `Hinh4.3_PhanTrang.png` | **Mục 3.2.2** | Giao diện phân trang AJAX (`page=2`), nạp mượt mà không reload trang. |
| 4 | `Hinh4.4_ChiTietSanPham.png` | **Mục 3.2.3** | Trang chi tiết tủ bếp (TB01): Album ảnh đa góc chụp thực tế, bảng thông số kỹ thuật và nút Chọn mua. |
| 5 | `Hinh4.5_GioHang.png` | **Mục 3.3** | Giỏ hàng trực tuyến: Bảng danh sách mặt hàng, số lượng, cập nhật số lượng, tạm tính và nút Đặt hàng. |
| 6 | `Hinh4.6_ChinhSachBaoHanh.png` | **Mục 3.4.1** | Trang chính sách bảo hành 24-36 tháng, bảo trì trọn đời sản phẩm. |
| 7 | `Hinh4.7_QuyTrinhKhaoSat.png` | **Mục 3.4.2** | Quy trình khảo sát tận nơi miễn phí, đo đạc laser và dựng bản vẽ 3D. |
| 8 | `Hinh4.8_DangKy.png` | **Mục 3.5.1** | Form đăng ký tài khoản khách hàng kèm validation kiểm tra SĐT bắt buộc. |
| 9 | `Hinh4.9_DangNhap.png` | **Mục 3.5.2** | Form đăng nhập tài khoản (xác thực Cookie và so khớp bảng băm PBKDF2). |
| 10 | `Hinh4.10_GioiThieu.png` | **Mục 3.1 phụ** | Trang giới thiệu thương hiệu KITCHENLUX và năng lực xưởng sản xuất. |
| 11 | `Hinh4.11_LienHe.png` | **Mục 3.1 phụ** | Trang liên hệ: Bản đồ showroom, hotline, email và form để lại yêu cầu tư vấn. |
| 12 | `Hinh4.12_WebAPI_JSON.png` | **Mục 3.6.1** | Dữ liệu RESTful API trả về định dạng JSON chuẩn qua route `/api/tubep`. |

---

## 9. ĐÁNH GIÁ KẾT QUẢ ĐẠT ĐƯỢC, HẠN CHẾ & HƯỚNG PHÁT TRIỂN (KẾT LUẬN)

### 9.1. Kết quả đạt được
1. **Nghiệp vụ:** Hiện thực đầy đủ 100% yêu cầu Đề tài 47: Quản lý danh mục tủ bếp phong phú, Bộ lọc đa tiêu chí, Quy trình đặt hàng khảo sát, Quản lý hóa đơn bán, Tìm kiếm đa tiêu chí (YC5) và trọn bộ 4 báo cáo thống kê đặc thù (YC6, YC7, YC8, YC9).
2. **Công nghệ:** Vận dụng chuẩn mực các kiến thức trọng tâm học phần Lập trình Web:
   - Kiến trúc phân lớp chuẩn mực ASP.NET Core MVC.
   - Tương tác CSDL qua Entity Framework Core (LINQ) kết hợp Triggers/Stored Procedures trong SQL Server 2022.
   - Quản lý trạng thái đa tầng với Session (giỏ hàng JSON) và Cookie Authentication (phân quyền vai trò).
   - Bảo mật mật khẩu người dùng với bảng băm PBKDF2 SHA-256 kèm Salt (`PasswordHasher<TaiKhoan>`).
   - Giao diện Responsive hiện đại bằng Bootstrap 5 mang phong cách kiến trúc nội thất cao cấp, trải nghiệm mượt mà với jQuery AJAX không reload trang.
   - Ứng dụng thành công kỹ thuật nâng cao ViewComponent và Web API RESTful.

### 9.2. Bài học kinh nghiệm rút ra
- Nắm vững quy trình phát triển phần mềm chuẩn mực từ khâu khảo sát nghiệp vụ, phân tích thiết kế Use-case/ERD, lập trình triển khai đến thiết kế kịch bản kiểm thử (Test Cases).
- Hiểu rõ tầm quan trọng của việc kiểm soát tính toàn vẹn dữ liệu (Data Integrity) giữa mã nguồn C# và hệ quản trị CSDL quan hệ SQL Server.
- Rèn luyện kỹ năng làm việc nhóm thực tế, quản lý phân nhánh và commit mã nguồn chuyên nghiệp thông qua công cụ Git & GitHub.

### 9.3. Hạn chế & Hướng phát triển trong tương lai
- **Hạn chế:**
  - Hệ thống hiện tại chỉ áp dụng hình thức thanh toán COD khi nhận hàng hoặc chuyển khoản quét mã QR thủ công, chưa tích hợp cổng thanh toán trực tuyến tự động.
  - Chưa tích hợp dịch vụ gửi email/SMS thông báo trạng thái đơn hàng tự động cho khách hàng.
- **Hướng phát triển:**
  - Tích hợp cổng thanh toán trực tuyến VNPay Sandbox phục vụ thanh toán đặt cọc đơn hàng online.
  - Xây dựng tính năng Chatbox tư vấn trực tuyến thời gian thực (ứng dụng thư viện **SignalR**) kết nối trực tiếp khách hàng với nhân viên.
  - Triển khai ứng dụng lên nền tảng máy chủ đám mây (Cloud Hosting) như MonsterASP.net hoặc Microsoft Azure.