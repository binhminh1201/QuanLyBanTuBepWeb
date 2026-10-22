# HƯỚNG DẪN DỰ ÁN THỰC HÀNH LAB 1 & LAB 2 (ASP.NET CORE MVC)

Dự án này được tạo và thiết lập hoàn chỉnh từ A đến Z tại thư mục:  
📂 `D:\DoStBetter\LTW\MyWebApp`

---

## 🚀 CÁCH KHỞI CHẠY DỰ ÁN

### Cách 1: Chạy bằng Visual Studio
1. Mở Visual Studio.
2. Chọn **Open a project or solution** ➔ Trỏ đến file `D:\DoStBetter\LTW\MyWebApp\MyWebApp.csproj`.
3. Nhấn phím `F5` hoặc nút `https / http` màu xanh trên thanh công cụ để chạy.

### Cách 2: Chạy bằng dòng lệnh (Terminal / PowerShell)
```powershell
cd D:\DoStBetter\LTW\MyWebApp
dotnet run
```
Trình duyệt sẽ mở tại địa chỉ: `http://localhost:5178` (hoặc `https://localhost:7296`).

---

## 📋 DANH SÁCH CÁC ROUTE TRUY CẬP

| Chức năng | Đường dẫn URL | Mô tả |
| :--- | :--- | :--- |
| **Trang chủ danh sách sinh viên** | `http://localhost:5178/` | Tự động chuyển đến danh sách sinh viên |
| **Danh sách sinh viên (Gốc)** | `http://localhost:5178/Student/Index` | Bảng quản lý sinh viên hiển thị qua SB Admin Layout |
| **Danh sách sinh viên (Route Lab 1)** | `http://localhost:5178/Admin/Student/List` | Cấu hình Route tùy biến theo đúng yêu cầu Mục 8 Lab 1 |
| **Form thêm mới sinh viên (Gốc)** | `http://localhost:5178/Student/Create` | Form nhập thông tin đầy đủ các control |
| **Form thêm mới sinh viên (Route Lab 1)** | `http://localhost:5178/Admin/Student/Add` | Cấu hình Route tùy biến theo đúng yêu cầu Mục 8 Lab 1 |

---

## 🏗️ CẤU TRÚC VÀ ĐỐI CHIẾU YÊU CẦU ĐỀ BÀI

### 1. BÀI THỰC HÀNH 1 (LAB 1)
- **`Models/Gender.cs`**: Enum giới tính (`Male`, `Female`).
- **`Models/Branch.cs`**: Enum chuyên ngành (`IT`, `BE`, `CE`, `EE`).
- **`Models/Student.cs`**: Thực thể sinh viên đầy đủ thuộc tính (`Id`, `Name`, `Email`, `Password`, `Branch`, `Gender`, `IsRegular`, `Address`, `DateOfBorth`, `Avatar`).
- **`Controllers/StudentController.cs`**:
  - Khởi tạo danh sách mẫu với 4 sinh viên như hình mẫu.
  - Action `Index`: Trả về danh sách sinh viên.
  - Action `Create` [HttpGet]: Nạp `ViewBag.AllGenders` và `ViewBag.AllBranches`.
  - Action `Create` [HttpPost]: Tự sinh ID tăng dần, xử lý lưu sinh viên và hỗ trợ upload ảnh đại diện (Mục 9 Lab 1).
  - Cấu hình Route: Hỗ trợ cả 2 route `/Admin/Student/List` và `/Admin/Student/Add`.
- **`Views/Student/Index.cshtml`**: Hiển thị bảng dữ liệu, Tag Helper `<a asp-action="Create">`, switch-case dịch tên ngành và giới tính sang tiếng Việt.
- **`Views/Student/Create.cshtml`**: Form sử dụng Tag Helpers (`asp-for`, `asp-controller`, `asp-action`, `<select>`, `<input type="radio">`, `<input type="checkbox">`, `<textarea>`).

### 2. BÀI THỰC HÀNH 2 (LAB 2)
- **Tài nguyên tĩnh**: Đã trích xuất CSS (`styles.css`) và JS (`scripts.js`) từ `startbootstrap_index` vào `wwwroot/css/` và `wwwroot/js/`.
- **`Views/Shared/MyLayout.cshtml`**: Layout chuẩn SB Admin chia nhỏ thành các Partial View:
  - `<partial name="TopNav" />` (`Views/Shared/TopNav.cshtml`)
  - `<partial name="LeftMenu" />` (`Views/Shared/LeftMenu.cshtml`)
  - `<partial name="Footer" />` (`Views/Shared/Footer.cshtml`)
  - `@RenderBody()`: Vị trí render trang con.
  - `@RenderSection("Scripts", required: false)`: Vị trí nhúng mã script riêng.
- **`Models/MenuItem.cs`**: Model cho menu động (`Id`, `Name`, `Link`).
- **`ViewComponents/RenderViewComponent.cs`**: Kế thừa `ViewComponent`, cung cấp dữ liệu menu Strongly Typed (`Branches`, `Students`, `Subjects`, `Courses`).
- **`Views/Shared/Components/Render/RenderLeftMenu.cshtml`**: View hiển thị menu động của ViewComponent.
- **`Views/Shared/MyLayoutHelper.cshtml`**: Layout nâng cao sử dụng ViewComponent `@await Component.InvokeAsync("Render")`.
- **Kiểm thử `@RenderSection`**: Trong `Views/Student/Index.cshtml`, click vào bảng sẽ kích hoạt đổi màu dòng tương tác.
