# HƯỚNG DẪN DỰ ÁN BÀI TẬP LỚN: XÂY DỰNG WEBSITE QUẢN LÝ BÁN TỦ BẾP
**Môn học:** Lập trình Web (ASP.NET Core MVC 10 + Entity Framework Core + SQL Server 2022)  
**Nhóm thực hiện:** Nhóm 5  
**Thư mục dự án:** `D:\DoStBetter\LTW\QuanLyBanTuBepWeb`

---

## 1. CÁC TÀI KHOẢN ĐĂNG NHẬP MẪU

| Loại tài khoản | Tên đăng nhập | Mật khẩu | Quyền hạn (Role) | Chức năng chính |
| :--- | :--- | :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin` | `123456` | `Admin` | Truy cập `/Admin`: Dashboard thống kê doanh thu, Quản lý tủ bếp (CRUD + Upload ảnh + CKEditor), Quản lý hóa đơn bán, Xem 4 báo cáo thống kê theo quý/tháng. |
| **Khách hàng** | `khach01` | `123456` | `KhachHang` | Xem bộ sưu tập tủ bếp, Lọc AJAX, Thêm giỏ hàng Session, Đặt hàng online, Xem lịch sử đơn hàng cá nhân. |

---

## 2. HƯỚNG DẪN CHẠY VÀ KIỂM TRA DỰ ÁN

### Cách 1: Sử dụng Visual Studio (Khuyên dùng)
1. Mở Visual Studio -> Chọn **Open a project or solution**.
2. Tìm đến thư mục `D:\DoStBetter\LTW\QuanLyBanTuBepWeb` và chọn tệp `QuanLyBanTuBepWeb.csproj`.
3. Nhấn **F5** (hoặc nút **Play - https/http**) để chạy ứng dụng trên trình duyệt.

### Cách 2: Sử dụng dòng lệnh (Terminal / PowerShell)
```powershell
cd "D:\DoStBetter\LTW\QuanLyBanTuBepWeb"
dotnet run
```
Sau đó mở trình duyệt và truy cập: `http://localhost:5000` hoặc cổng được hiển thị trên màn hình console.

---

## 3. DANH SÁCH CÁC TÍNH NĂNG ĐÃ HIỆN THỰC CỦA HỆ THỐNG

1. **Kiến trúc phân hệ 2 lớp người dùng**:
   - Giao diện Showroom Tủ bếp dành cho Khách hàng (`/Home`, `/Product`, `/Cart`, `/Account`).
   - Phân hệ quản trị độc lập dành cho Quản trị viên (`/Admin/Home`, `/Admin/DMHangHoa`, `/Admin/HoaDonBan`, `/Admin/BaoCao`).
2. **Bộ lọc và tương tác AJAX**:
   - Lọc tủ bếp đa tiêu chí theo Chất liệu, Màu sắc, Kích thước, Xuất xứ, Khoảng giá.
   - Tìm kiếm từ khóa theo tên hoặc mã tủ bếp.
   - Phân trang động (Paging) bằng AJAX kết hợp jQuery và `PartialView("_ProductListPartial")` hoàn toàn không tải lại trang.
3. **Quản lý trạng thái (Session & Cookies)**:
   - Giỏ hàng (Shopping Cart) lưu trữ trong Session qua `JsonSerializer` (`CartController.cs` & `SessionExtensions.cs`).
   - Đăng nhập ghi nhớ và phân quyền qua Cookie (`CookieAuthenticationDefaults`).
4. **Kiểm tra tính hợp lệ dữ liệu (Data Annotations & Validation)**:
   - Ràng buộc Model (`[Required]`, `[Range]`, `[RegularExpression]`, `[Compare]`).
   - Bẫy lỗi và hiển thị thông báo ở cả Client (jQuery Validate) và Server (`ModelState.IsValid`).
5. **Upload file hình ảnh & Trình soạn thảo CKEditor**:
   - Tải lên file ảnh tủ bếp qua `IFormFile` lưu vào `wwwroot/images/products/`.
   - Tích hợp trình soạn thảo văn bản CKEditor cho trường mô tả, thông số kỹ thuật sản phẩm.
6. **Đóng gói giao diện độc lập với ViewComponent**:
   - Đóng gói thanh lọc Sidebar động thành `ProductFilterSidebarViewComponent` tự quản lý truy vấn 4 danh mục (Chất liệu, Màu sắc, Kích thước, Xuất xứ) tách biệt hoàn toàn khỏi Controller.
7. **Dịch vụ Web API RESTful**:
   - Endpoint `GET /api/tubep` trả về danh sách tủ bếp định dạng JSON.
   - Endpoint `GET /api/tubep/{id}` trả về chi tiết tủ bếp theo ID.
8. **Hệ thống 4 Báo cáo thống kê chuyên sâu**:
   - `sp_BaoCaoTop3SanPhamTheoQuy`: Top 3 sản phẩm bán chạy nhất trong quý.
   - `sp_BaoCaoHoaDonNhapTheoNV`: Báo cáo chi tiết hóa đơn nhập hàng do nhân viên nhập.
   - `sp_BaoCaoTop5HDBanNhoNhatTheoQuy`: Báo cáo 5 hóa đơn bán hàng có giá trị nhỏ nhất trong quý.
   - `sp_BaoCaoKhachHangTheoThang`: Danh sách khách hàng và doanh số bán hàng theo tháng.
9. **Tìm kiếm hóa đơn bán đa tiêu chí**:
   - Tìm kiếm kết hợp theo Mã hàng hoá trong hóa đơn, Khoảng ngày bán và Khoảng tổng tiền.

---

## 4. TÀI LIỆU HỖ TRỢ LÀM BÁO CÁO BÀI TẬP LỚN

### Sơ đồ Ca Sử Dụng (Use-Case Diagram) - Dùng vẽ lại trên Draw.io

```mermaid
flowchart LR
    KhachHang((Khách Hàng))
    Admin((Quản Trị Viên))

    subgraph "Hệ Thống Quản Lý Bán Tủ Bếp KITCHENLUX"
        UC1[Xem bộ sưu tập tủ bếp]
        UC2[Tìm kiếm & Lọc AJAX]
        UC3[Thêm vào Giỏ hàng Session]
        UC4[Đặt hàng online & Khảo sát]
        UC5[Đăng ký & Đăng nhập]
        UC6[Xem lịch sử đơn hàng cá nhân]
        
        UC7[Quản lý danh mục Tủ Bếp CRUD]
        UC8[Upload ảnh & Soạn thảo CKEditor]
        UC9[Quản lý & Tìm kiếm Hoá đơn bán]
        UC10[Xem 4 Báo cáo thống kê đề tài]
        UC11[Quản trị tài khoản & Dashboard]
    end

    KhachHang --> UC1
    KhachHang --> UC2
    KhachHang --> UC3
    KhachHang --> UC4
    KhachHang --> UC5
    KhachHang --> UC6

    Admin --> UC5
    Admin --> UC7
    Admin --> UC8
    Admin --> UC9
    Admin --> UC10
    Admin --> UC11
```

### Bảng Kịch Bản Kiểm Thử Mẫu (Test Cases) - Dán vào Mục 5.4 của Báo Cáo

| ID | Chức năng test | Dữ liệu đầu vào | Kết quả kỳ vọng | Kết quả thực tế | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC01** | Lọc tủ bếp bằng AJAX | Chọn chất liệu: "Gỗ Acrylic bóng gương" | Danh sách cập nhật các tủ Acrylic, không load lại trang web | Khung danh sách cập nhật mượt mà qua PartialView | **PASS** |
| **TC02** | Phân trang AJAX | Bấm chuyển sang "Trang 2" | Hiển thị 6 sản phẩm tiếp theo, thanh URL giữ nguyên | Chuyển trang thành công bằng jQuery AJAX | **PASS** |
| **TC03** | Thêm vào giỏ hàng | Bấm nút "Chọn mua" trên sản phẩm TB01 | Badge giỏ hàng góc phải tăng thêm 1, hiện Toast thông báo | Badge nhảy từ 0 lên 1, hiện popup Toast góc dưới | **PASS** |
| **TC04** | Đặt hàng khi form trống | Để trống SĐT và bấm "Xác Nhận Đặt Hàng" | Báo lỗi validation "Số điện thoại không được để trống" | Hiện dòng chữ đỏ báo lỗi tại ô SĐT | **PASS** |
| **TC05** | Đặt hàng thành công | Nhập đầy đủ Tên, SĐT, Địa chỉ | Tạo mới HĐ bán trong DB, chuyển sang trang OrderSuccess | Sinh mã HDB thành công, giỏ hàng tự động làm trống | **PASS** |
| **TC06** | Đăng nhập Admin | Tài khoản `admin` / pass `123456` | Chuyển hướng vào trang Dashboard quản trị `/Admin` | Đăng nhập thành công, mở giao diện SB Admin | **PASS** |
| **TC07** | Thêm mới tủ bếp kèm ảnh | Nhập thông tin TB06, chọn file ảnh `.jpg` | Thêm vào CSDL, file ảnh lưu trong `wwwroot/images/products/` | Hiển thị trong bảng quản trị với ảnh vừa chọn | **PASS** |
| **TC08** | Báo cáo Top 3 theo Quý | Chọn Năm: 2026, Quý: 1 | Trả về 3 sản phẩm bán chạy nhất Quý 1/2026 theo đúng DB | Hiện chính xác 3 sản phẩm TB01, TB04, TB02 | **PASS** |
| **TC09** | Báo cáo HĐ Nhập theo NV | Chọn nhân viên: "NV04 - Phạm Thu Hà" | Trả về chi tiết các đợt nhập hàng của NV04 kèm tổng tiền | Hiển thị chính xác các hóa đơn HDN01 - HDN04 của NV04 | **PASS** |
| **TC10** | Tìm kiếm HĐ bán đa tiêu chí | Chọn mặt hàng "TB01" và Tổng tiền từ "10.000.000" | Lọc ra các hóa đơn bán chứa TB01 có tổng giá trị >= 10tr | Lọc chính xác các hóa đơn HDB01, HDB03 | **PASS** |
