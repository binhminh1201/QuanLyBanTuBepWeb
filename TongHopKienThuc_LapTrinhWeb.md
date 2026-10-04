# SỔ TAY TỔNG HỢP KIẾN THỨC TOÀN DIỆN MÔN HỌC: LẬP TRÌNH WEB (ASP.NET CORE MVC)

> **Tài liệu tham chiếu chuẩn**: Dựa trên toàn bộ slide bài giảng lý thuyết (Chương 0 - 10), hệ thống 6 bài thực hành (Lab 1 - Lab 6), bộ 13 video bài giảng mẫu và đề cương yêu cầu Bài tập lớn môn Lập trình Web.

---

## MỤC LỤC

1. [Chương 1: Tổng Quan & Kiến Trúc ASP.NET Core MVC](#chương-1-tổng-quan--kiến-trúc-aspnet-core-mvc)
2. [Chương 2: Cấu Hình Dự Án & Routing (Định Tuyến)](#chương-2-cấu-hình-dự-án--routing-định-tuyến)
3. [Chương 3: Controller & Các Kiểu Action Result](#chương-3-controller--các-kiểu-action-result)
4. [Chương 4: View, Razor Engine & Tag Helpers](#chương-4-view-razor-engine--tag-helpers)
5. [Chương 5: Layout, Partial View & ViewComponent](#chương-5-layout-partial-view--viewcomponent)
6. [Chương 6: Model, Data Annotations & Kiểm Soát Dữ Liệu (Validation)](#chương-6-model-data-annotations--kiểm-soát-dữ-liệu-validation)
7. [Chương 7: Quản Lý Trạng Thái (State Management - Session, Cookies, TempData)](#chương-7-quản-lý-trạng-thái-state-management---session-cookies-tempdata)
8. [Chương 8: Truy Xuất Dữ Liệu Với Entity Framework Core (EF Core)](#chương-8-truy-xuất-dữ-liệu-với-entity-framework-core-ef-core)
9. [Chương 9: Kỹ Thuật AJAX Trong ASP.NET Core (Lọc, Tìm Kiếm & Phân Trang)](#chương-9-kỹ-thuật-ajax-trong-aspnet-core-lọc-tìm-kiếm--phân-trang)
10. [Chương 10: Các Chức Năng Nâng Cao Thực Tế (Upload File, Editor, Security, i18n, Areas)](#chương-10-các-chức-năng-nâng-cao-thực-tế)
11. [Chương 11: Tổng Kết Các Mẫu Code Chuẩn Theo Hệ Thống Bài Lab (Lab 1 - Lab 6)](#chương-11-tổng-kết-các-mẫu-code-chuẩn-theo-hệ-thống-bài-lab)
12. [Chương 12: Checklist Chuẩn Bị & Quy Chuẩn Bài Tập Lớn / Thi Cuối Kỳ](#chương-12-checklist-chuẩn-bị--quy-chuẩn-bài-tập-lớn--thi-cuối-kỳ)

---

## CHƯƠNG 1: TỔNG QUAN & KIẾN TRÚC ASP.NET CORE MVC

### 1. Mô hình MVC (Model - View - Controller)
- **Model**: Đại diện cho dữ liệu và quy tắc nghiệp vụ của ứng dụng (Business Rules, Validation, tương tác CSDL thông qua ORM).
- **View**: Thành phần hiển thị giao diện người dùng (UI), nhận dữ liệu từ Controller để hiển thị và tương tác với người dùng qua HTML/CSS/JS.
- **Controller**: Thành phần điều phối, tiếp nhận HTTP Request từ client, tương tác với Model để lấy hoặc cập nhật dữ liệu, sau đó chọn View thích hợp để trả kết quả về cho client.

### 2. Ưu thế của ASP.NET Core MVC
- **Đa nền tảng (Cross-platform)**: Chạy tốt trên Windows, Linux, macOS.
- **Hiệu năng cao (High Performance)**: Cơ chế pipeline xử lý HTTP request dạng mô-đun siêu nhẹ thông qua middleware.
- **Tích hợp sẵn Dependency Injection (DI)**: Quản lý vòng đời dịch vụ (`Transient`, `Scoped`, `Singleton`) mà không cần thư viện ngoài.
- **Hỗ trợ đồng bộ cả Web UI và Web API**: Sử dụng chung cơ chế Controller, Action, Filter, Model Binding.

---

## CHƯƠNG 2: CẤU HÌNH DỰ ÁN & ROUTING (ĐỊNH TUYẾN)

### 1. Vòng đời Request và Cấu hình trong `Program.cs`
Trong .NET 6/7/8/9/10, cấu hình pipeline và container dịch vụ được tối giản trong tệp `Program.cs`:

```csharp
var builder = WebApplication.CreateBuilder(args);

// 1. Đăng ký các dịch vụ (Services Container)
builder.Services.AddControllersWithViews();

// Cấu hình Session
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Đăng ký DbContext với chuỗi kết nối SQL Server
builder.Services.AddDbContext<SchoolContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// 2. Cấu hình HTTP Request Pipeline (Middlewares)
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles(); // Cho phép truy cập wwwroot (css, js, images)

app.UseRouting();
app.UseSession(); // Bắt buộc đặt giữa UseRouting() và UseAuthorization()
app.UseAuthentication();
app.UseAuthorization();

// 3. Cấu hình Routing mặc định
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

### 2. Hai cơ chế Routing
1. **Conventional Routing (Định tuyến quy ước)**: Khai báo trong `Program.cs` thông qua `pattern: "{controller}/{action}/{id?}"`.
2. **Attribute Routing (Định tuyến thuộc tính)**: Khai báo trực tiếp trên đầu Controller hoặc Action method:
   ```csharp
   [Route("Admin/[controller]/[action]")]
   public class StudentController : Controller
   {
       [Route("Danh-Sach-Sinh-Vien")]
       public IActionResult Index() => View();
   }
   ```

---

## CHƯƠNG 3: CONTROLLER & CÁC KIỂU ACTION RESULT

### 1. Phân loại Action Results
Các phương thức trong Controller thường trả về kiểu `IActionResult` hoặc `ActionResult<T>`:

| Tên phương thức | Lớp trả về | Mục đích sử dụng |
| :--- | :--- | :--- |
| `View()` | `ViewResult` | Trả về giao diện HTML đầy đủ theo View tương ứng |
| `PartialView()` | `PartialViewResult` | Trả về một phần giao diện HTML (thường dùng cho AJAX) |
| `Json(data)` | `JsonResult` | Trả về dữ liệu dạng JSON cho Web API hoặc AJAX |
| `Content(text)` | `ContentResult` | Trả về chuỗi văn bản thô (Plain text / HTML string) |
| `RedirectToAction()` | `RedirectToActionResult` | Chuyển hướng sang một Action khác trong cùng/khác Controller |
| `Redirect()` | `RedirectResult` | Chuyển hướng đến một URL cố định |
| `NotFound()` | `NotFoundResult` | Trả về mã lỗi HTTP 404 (Không tìm thấy tài nguyên) |
| `BadRequest()` | `BadRequestResult` | Trả về mã lỗi HTTP 400 (Dữ liệu gửi lên sai quy cách) |
| `File()` | `FileResult` | Tải xuống tệp tin từ server |

### 2. Model Binding & Nhận dữ liệu đầu vào
ASP.NET Core tự động trích xuất dữ liệu từ HTTP Request đưa vào tham số của Action theo thứ tự:
1. **Form values** (`[FromForm]`): Dữ liệu gửi từ form HTML phương thức POST.
2. **Route values** (`[FromRoute]`): Dữ liệu trích từ URL theo route pattern (ví dụ: `/Student/Edit/5`).
3. **Query strings** (`[FromQuery]`): Tham số đính kèm sau dấu chấm hỏi (ví dụ: `/Student?mid=1&keyword=Nam`).
4. **Header / Body** (`[FromHeader]`, `[FromBody]`): JSON object trong request body (Web API).

---

## CHƯƠNG 4: VIEW, RAZOR ENGINE & TAG HELPERS

### 1. Cú pháp Razor C#
- Dùng ký hiệu `@` để chuyển đổi giữa HTML và C#:
  - Khai báo model: `@model IEnumerable<Student>`
  - Biểu thức đơn: `@DateTime.Now.Year` hoặc `@(Model.Price * 1.1)`
  - Khối mã C#: `@{ var title = "Trang chủ"; }`
  - Vòng lặp: `@foreach (var item in Model) { <tr><td>@item.Name</td></tr> }`
  - Điều kiện: `@if (item.IsRegular) { <span>Chính quy</span> }`

### 2. So sánh HTML Helpers cổ điển và Tag Helpers hiện đại
ASP.NET Core ưu tiên dùng **Tag Helpers** vì giữ nguyên cú pháp thẻ HTML tự nhiên:

| HTML Helper cổ điển | Tag Helper hiện đại | Chức năng |
| :--- | :--- | :--- |
| `@Html.ActionLink("Tạo", "Create")` | `<a asp-action="Create">Tạo</a>` | Tạo thẻ liên kết `<a>` |
| `@Html.TextBoxFor(m => m.Name)` | `<input asp-for="Name" />` | Input liên kết thuộc tính Model |
| `@Html.ValidationMessageFor(m => m.Name)` | `<span asp-validation-for="Name"></span>` | Hiển thị thông báo lỗi của trường |
| `@Html.ValidationSummary()` | `<div asp-validation-summary="All"></div>` | Hiển thị tổng hợp các lỗi form |
| `@Html.DropDownListFor(...)` | `<select asp-for="MajorID" asp-items="ViewBag.MajorID"></select>` | Tạo dropdown chọn dữ liệu |

---

## CHƯƠNG 5: LAYOUT, PARTIAL VIEW & VIEWCOMPONENT

### 1. Cấu trúc Layout chuẩn
- **`_ViewStart.cshtml`**: Tự động áp dụng Layout mặc định cho tất cả các View trong thư mục:
  ```razor
  @{
      Layout = "_Layout";
  }
  ```
- **`_Layout.cshtml`**: Khung sườn chung của trang web (Header, Sidebar, Content, Footer):
  - `@RenderBody()`: Vị trí render nội dung riêng của từng trang.
  - `@RenderSection("Scripts", required: false)`: Vị trí nhúng mã script riêng của trang con vào cuối trang layout.

### 2. Partial View vs ViewComponent

| Tiêu chí | Partial View | ViewComponent |
| :--- | :--- | :--- |
| **Bản chất** | Chỉ là một tệp `.cshtml` phụ trợ | Gồm một Class C# logic + một tệp `.cshtml` view |
| **Logic nghiệp vụ** | Không có Controller/Logic riêng, phụ thuộc vào View cha | Có logic độc lập (truy vấn DB, tính toán riêng) |
| **Vị trí lưu trữ** | Thường để ở `Views/Shared/` hoặc `Views/[Controller]/` | Class ở thư mục `ViewComponents/`, View ở `Views/Shared/Components/[TênComponent]/Default.cshtml` |
| **Cách gọi trên View** | `<partial name="_Header" />` | `@await Component.InvokeAsync("TênComponent", new { mid = 1 })` |
| **Mục đích phù hợp** | Tái sử dụng giao diện tĩnh (TopNav, Footer) | Tái sử dụng giao diện có kèm dữ liệu động (Menu chuyên mục, Giỏ hàng mini) |

#### Cấu trúc tạo một ViewComponent chuẩn:
1. **Lớp ViewComponent (`ViewComponents/MajorViewComponent.cs`)**:
   ```csharp
   public class MajorViewComponent : ViewComponent
   {
       private readonly SchoolContext _context;
       public MajorViewComponent(SchoolContext context) => _context = context;

       public async Task<IViewComponentResult> InvokeAsync()
       {
           var majors = await _context.Majors.ToListAsync();
           return View("RenderMajor", majors);
       }
   }
   ```
2. **View giao diện (`Views/Shared/Components/Major/RenderMajor.cshtml`)**:
   ```razor
   @model IEnumerable<Major>
   <ul class="nav">
       @foreach(var item in Model) {
           <li class="nav-item" id="@item.MajorID"><a class="nav-link">@item.MajorName</a></li>
       }
   </ul>
   ```

---

## CHƯƠNG 6: MODEL, DATA ANNOTATIONS & KIỂM SOÁT DỮ LIỆU (VALIDATION)

### 1. Bảng tra cứu các Data Annotations phổ biến

| Annotation | Ý nghĩa & Cú pháp mẫu |
| :--- | :--- |
| `[Required]` | Bắt buộc nhập: `[Required(ErrorMessage = "Vui lòng nhập họ tên")]` |
| `[StringLength]` | Độ dài chuỗi: `[StringLength(100, MinimumLength = 4, ErrorMessage = "Tên từ 4 - 100 ký tự")]` |
| `[RegularExpression]` | Biểu thức chính quy (Regex): `[RegularExpression(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$", ErrorMessage = "Email không hợp lệ")]` |
| `[Range]` | Giới hạn khoảng giá trị (số, ngày): `[Range(0.0, 10.0, ErrorMessage = "Điểm từ 0 đến 10")]` hoặc `[Range(typeof(DateTime), "1/1/1960", "12/31/2005")]` |
| `[Compare]` | So sánh trùng khớp (ví dụ mật khẩu): `[Compare("Password", ErrorMessage = "Mật khẩu xác nhận không khớp")]` |
| `[Display]` | Tên nhãn hiển thị thân thiện: `[Display(Name = "Họ và Tên")]` |
| `[DataType]` | Định dạng hiển thị và input type: `[DataType(DataType.Password)]`, `[DataType(DataType.Date)]` |

### 2. Quy trình xử lý Validation trong Controller
```csharp
[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> Create(Student student)
{
    if (ModelState.IsValid)
    {
        _context.Add(student);
        await _context.SaveChangesAsync();
        return RedirectToAction(nameof(Index));
    }
    // Nếu có lỗi, tái tạo lại danh sách dropdown và trả lại View kèm dữ liệu cũ
    ViewBag.AllBranches = GetBranches();
    return View(student);
}
```

---

## CHƯƠNG 7: QUẢN LÝ TRẠNG THÁI (STATE MANAGEMENT)

Vì giao thức HTTP là **stateless** (không lưu trạng thái giữa các lần gửi request), ASP.NET Core cung cấp các công cụ quản lý trạng thái sau:

### 1. Bảng so sánh các kỹ thuật State Management

| Kỹ thuật | Nơi lưu trữ | Vòng đời tồn tại | Phạm vi dữ liệu | Mục đích phổ biến |
| :--- | :--- | :--- | :--- | :--- |
| **Cookies** | Phía Client (trình duyệt) | Theo thời gian hết hạn (`Expires`) | Chuỗi text nhỏ (tối đa ~4KB) | Lưu ghi nhớ tài khoản (`Remember Me`), cài đặt ngôn ngữ, theme |
| **Session** | Phía Server (gắn SessionID vào Cookie) | Mất khi đóng phiên làm việc hoặc timeout | Dữ liệu đối tượng phức tạp (JSON) | Quản lý phiên đăng nhập, Giỏ hàng (Shopping Cart) |
| **TempData** | Phía Server (Session-backed) | Chỉ tồn tại cho request kế tiếp | Đối tượng dữ liệu | Truyền thông báo sau khi Redirect (`"Thêm mới thành công"`) |
| **ViewBag / ViewData** | Bộ nhớ RAM | Chỉ trong 1 request duy nhất giữa Controller và View | Dynamic object / Dictionary | Truyền danh sách Dropdown, tiêu đề trang |

### 2. Mẫu triển khai Giỏ hàng (Shopping Cart) dùng Session & JSON Helper
Trong ASP.NET Core, Session chỉ hỗ trợ lưu `byte[]` và `string`. Muốn lưu đối tượng/danh sách phức tạp, ta mở rộng (Extension Method) để tuần tự hóa (serialize) sang JSON:

```csharp
// SessionExtensions.cs
public static class SessionExtensions
{
    public static void SetObjectAsJson(this ISession session, string key, object value)
    {
        session.SetString(key, JsonSerializer.Serialize(value));
    }

    public static T? GetObjectFromJson<T>(this ISession session, string key)
    {
        var value = session.GetString(key);
        return value == null ? default : JsonSerializer.Deserialize<T>(value);
    }
}
```

---

## CHƯƠNG 8: TRUY XUẤT DỮ LIỆU VỚI ENTITY FRAMEWORK CORE (EF CORE)

### 1. Hai hướng tiếp cận chính
1. **Code First**:
   - Lập trình viên thiết kế các Class Entity (Model C#) trước.
   - Định nghĩa lớp `DbContext` chứa các `DbSet<T>`.
   - Chạy lệnh Migration (`Add-Migration InitialCreate` -> `Update-Database`) hoặc `context.Database.EnsureCreated()` để sinh ra CSDL SQL Server tương ứng.
2. **Database First**:
   - CSDL đã có sẵn trên SQL Server.
   - Dùng lệnh Scaffolding sinh ngược mã nguồn Model và DbContext vào dự án:
     ```powershell
     Scaffold-DbContext "Server=.;Database=SchoolDB;Trusted_Connection=True;TrustServerCertificate=True;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models
     ```

### 2. Mẫu tạo DbContext & Khởi tạo dữ liệu mẫu (`DbInitializer`)
```csharp
public class SchoolContext : DbContext
{
    public SchoolContext(DbContextOptions<SchoolContext> options) : base(options) { }

    public DbSet<Major> Majors { get; set; }
    public DbSet<Learner> Learners { get; set; }
    public DbSet<Course> Courses { get; set; }
    public DbSet<Enrollment> Enrollments { get; set; }
}

public static class DbInitializer
{
    public static void Initialize(SchoolContext context)
    {
        context.Database.EnsureCreated();
        if (context.Majors.Any()) return; // Đã có dữ liệu thì bỏ qua

        var majors = new Major[]
        {
            new Major { MajorName = "IT" },
            new Major { MajorName = "Economics" }
        };
        context.Majors.AddRange(majors);
        context.SaveChanges();
    }
}
```

### 3. Các truy vấn LINQ thường dùng trong Controller
- **Lấy danh sách có nạp dữ liệu bảng liên kết (Eager Loading)**:
  ```csharp
  var learners = await db.Learners.Include(l => l.Major).ToListAsync();
  ```
- **Tìm kiếm & Lọc (Filtering)**:
  ```csharp
  var result = db.Learners.Where(l => l.MajorID == mid && l.FirstMidName.Contains(keyword));
  ```
- **Kiểm tra khóa ngoại trước khi Xóa (Cascade/Prevent Delete)**:
  ```csharp
  var learner = await db.Learners.Include(l => l.Enrollments).FirstOrDefaultAsync(l => l.LearnerID == id);
  if (learner.Enrollments.Any())
  {
      return Content("Không thể xóa sinh viên này do đã đăng ký khóa học!");
  }
  db.Learners.Remove(learner);
  await db.SaveChangesAsync();
  ```

---

## CHƯƠNG 9: KỸ THUẬT AJAX TRONG ASP.NET CORE (LỌC, TÌM KIẾM & PHÂN TRANG)

Một yêu cầu bắt buộc và quan trọng hàng đầu trong môn học là xử lý **AJAX mượt mà không tải lại toàn trang**.

### 1. Kiến trúc AJAX phân trang + Lọc + Tìm kiếm kết hợp
1. Phía Server: Controller trả về một `PartialView` chỉ chứa phần bảng dữ liệu (`<table>`) và thanh phân trang.
2. Phía Client: jQuery gửi tham số `{ mid, keyword, pageIndex }` lên Action, khi nhận được HTML trả về sẽ gán đè vào thẻ `<div id="content">`.

### 2. Code Controller mẫu (`LearnerController.cs`)
```csharp
private int pageSize = 3;

public IActionResult LearnerFilter(int? mid, string? keyword, int? pageIndex)
{
    var query = db.Learners.Include(m => m.Major).AsQueryable();

    // 1. Lọc theo ngành
    if (mid != null)
    {
        query = query.Where(l => l.MajorID == mid);
        ViewBag.mid = mid;
    }

    // 2. Tìm kiếm theo từ khóa
    if (!string.IsNullOrEmpty(keyword))
    {
        query = query.Where(l => l.FirstMidName.ToLower().Contains(keyword.ToLower()) 
                              || l.LastName.ToLower().Contains(keyword.ToLower()));
        ViewBag.keyword = keyword;
    }

    // 3. Tính toán phân trang
    int page = pageIndex ?? 1;
    int totalItems = query.Count();
    int pageNum = (int)Math.Ceiling(totalItems / (float)pageSize);
    ViewBag.pageNum = pageNum;
    ViewBag.currentPage = page;

    var result = query.Skip(pageSize * (page - 1)).Take(pageSize).ToList();
    return PartialView("LearnerTable", result);
}
```

### 3. Code Client AJAX jQuery (`Index.cshtml`)
```javascript
function loadData(pageIndex) {
    var mid = $("#currentMid").val();
    var keyword = $("#keyword").val();

    $.ajax({
        url: "/Learner/LearnerFilter",
        type: "GET",
        data: { mid: mid, keyword: keyword, pageIndex: pageIndex },
        success: function (response) {
            $("#content").html(response);
        },
        error: function (xhr) {
            alert("Lỗi tải dữ liệu: " + xhr.statusText);
        }
    });
}

// Bắt sự kiện click vào nút tìm kiếm
$("#btnSearch").click(function () {
    loadData(1);
});

// Bắt sự kiện click vào chuyển trang (Ủy thác sự kiện - Event Delegation)
$("body").on("click", "li.page-item", function () {
    var page = $(this).attr("page");
    loadData(page);
});

// Bắt sự kiện click vào chuyên ngành (Nav item)
$(".nav li").click(function () {
    var mid = $(this).attr("id");
    $("#currentMid").val(mid);
    loadData(1);
});
```

---

## CHƯƠNG 10: CÁC CHỨC NĂNG NÂNG CAO THỰC TẾ

### 1. Phân vùng quản trị (Areas)
Dùng để tách biệt giao diện và logic của hệ thống quản trị (`Admin`) và giao diện khách hàng:
- Cấu trúc thư mục: `Areas/Admin/Controllers/`, `Areas/Admin/Views/`
- Thêm Annotation trên Controller:
  ```csharp
  [Area("Admin")]
  public class HomeController : Controller { ... }
  ```
- Cấu hình route Area trong `Program.cs`:
  ```csharp
  app.MapControllerRoute(
      name: "areas",
      pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
  ```

### 2. Tải lên tệp ảnh (Upload File)
- Thuộc tính Model dùng kiểu `IFormFile`:
  ```csharp
  public class StudentInputModel
  {
      public string Name { get; set; }
      public IFormFile? AvatarFile { get; set; }
  }
  ```
- Form HTML bắt buộc có thuộc tính: `enctype="multipart/form-data"`:
  ```html
  <form asp-action="Create" method="post" enctype="multipart/form-data">
      <input type="file" asp-for="AvatarFile" class="form-control" />
  </form>
  ```
- Xử lý lưu file trong Controller:
  ```csharp
  if (model.AvatarFile != null && model.AvatarFile.Length > 0)
  {
      var fileName = Guid.NewGuid().ToString() + Path.GetExtension(model.AvatarFile.FileName);
      var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/avatars", fileName);
      using (var stream = new FileStream(filePath, FileMode.Create))
      {
          await model.AvatarFile.CopyToAsync(stream);
      }
      student.Avatar = "/images/avatars/" + fileName;
  }
  ```

### 3. Tích hợp Trình soạn thảo văn bản phong phú (CKEditor / TinyMCE)
- Dùng cho các trường mô tả sản phẩm, bài viết tin tức:
  ```html
  <textarea asp-for="Description" id="editor"></textarea>
  <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
  <script>
      CKEDITOR.replace('editor');
  </script>
  ```

### 4. Bảo mật ứng dụng
- **Chống tấn công CSRF (Cross-Site Request Forgery)**: Luôn gắn `[ValidateAntiForgeryToken]` trên các Action HttpPost và đặt `<form>` với Tag Helper (tự sinh `@Html.AntiForgeryToken()`).
- **Chống tấn công XSS (Cross-Site Scripting)**: Razor mặc định encode toàn bộ chuỗi `@Model.Content`. Chỉ dùng `@Html.Raw()` khi chuỗi HTML đã được kiểm duyệt an toàn.

---

## CHƯƠNG 11: TỔNG KẾT HỆ THỐNG BÀI LAB THỰC HÀNH (LAB 1 - LAB 6)

| Bài Lab | Trọng tâm thực hành | Kỹ năng đạt được sau bài lab |
| :--- | :--- | :--- |
| **Lab 1** | Xây dựng CRUD sinh viên cơ bản bằng danh sách mẫu | Khởi tạo Model, Enum, Controller, View, Tag Helper, cấu hình định tuyến Route tùy biến. |
| **Lab 2** | Ghép template Web (SB Admin) vào dự án | Cắt ghép Layout, chia nhỏ Partial Views, xây dựng ViewComponent để hiển thị menu động Strongly Typed. |
| **Lab 3** | Kiểm soát dữ liệu với Data Annotations | Thiết lập ràng buộc (Regex, Required, Range...), bẫy lỗi `ModelState.IsValid`, hiển thị thông báo lỗi Tiếng Việt. |
| **Lab 4** | Kết nối CSDL SQL Server với EF Core | Thực hành Code First & DB First, thiết kế quan hệ bảng, DbInitializer, viết CRUD đầy đủ trên CSDL thực tế. |
| **Lab 5** | Xây dựng chức năng Lọc dữ liệu kết hợp AJAX | Tạo ViewComponent hiển thị danh mục, viết Action trả về PartialView, bắt sự kiện click gọi AJAX cập nhật bảng. |
| **Lab 6** | Phân trang, Tìm kiếm kết hợp Lọc bằng AJAX | Sử dụng toán tử LINQ `.Skip()`, `.Take()`, viết thuật toán phân trang động, xử lý chuỗi sự kiện tương tác hoàn toàn bất đồng bộ. |

---

## CHƯƠNG 12: CHECKLIST BÀI TẬP LỚN & THI CUỐI KỲ

Khi chuẩn bị hoàn thiện sản phẩm Bài tập lớn môn học, cần đối chiếu với bảng kiểm tra sau (theo đúng [YeuCauBaiTapLon.pdf](file:///d:/LTW/YeuCauBaiTapLon.pdf)):

- [ ] **1. Phân quyền người dùng**: Tối thiểu 2 role độc lập (Khách hàng / Thành viên vs Quản trị viên Admin).
- [ ] **2. Thiết kế giao diện**: Sử dụng template hoàn chỉnh, có Responsive (Bootstrap), thân thiện trên Desktop & Mobile.
- [ ] **3. Thao tác dữ liệu (CRUD)**: Đầy đủ Thêm, Sửa, Xóa, Chi tiết trên các bảng chính, bắt ràng buộc toàn vẹn khóa ngoại.
- [ ] **4. Bộ tính năng bắt buộc**:
  - [ ] Tìm kiếm (Search) theo từ khóa.
  - [ ] Lọc dữ liệu (Filter) theo chuyên mục / trạng thái.
  - [ ] Phân trang (Paging).
  - [ ] AJAX cho toàn bộ các thao tác trên (không giật trang).
- [ ] **5. Quản lý trạng thái**: Sử dụng Session cho chức năng Giỏ hàng (E-commerce) hoặc Quản lý phiên đăng nhập, sử dụng Cookie ghi nhớ.
- [ ] **6. Kiểm tra dữ liệu (Validation)**: Kiểm soát định dạng đầy đủ ở cả Client và Server bằng Data Annotations.
- [ ] **7. Mở rộng**: Tải lên ảnh (Upload image), tích hợp Rich Text Editor (CKEditor), cung cấp Web API RESTful endpoint.
- [ ] **8. Hồ sơ nộp bài**:
  - Báo cáo Word/PDF từ 15 đến 35 trang theo quy chuẩn (Font Times New Roman 13, dãn dòng 1.1, lề trên 2cm, dưới 2cm, trái 1.5cm, phải 1.5cm, gáy 2cm).
  - File kịch bản CSDL `.sql` đầy đủ bảng và dữ liệu mẫu.
  - Mã nguồn chương trình nén dạng `.zip` hoặc `.zar` theo quy tắc: `[TenCSDL]_[NhomX]_[Lop].zip`.
