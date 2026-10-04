using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using QuanLyBanTuBepWeb.Models;

var builder = WebApplication.CreateBuilder(args);

// Đảm bảo WebRootPath luôn trỏ đúng thư mục wwwroot chứa css, js, images
var currentDir = new DirectoryInfo(Directory.GetCurrentDirectory());
if (!Directory.Exists(Path.Combine(currentDir.FullName, "wwwroot")))
{
    // Nếu chạy từ thư mục bin/Debug/net10.0, tìm ngược lên thư mục dự án
    var baseDir = new DirectoryInfo(AppContext.BaseDirectory);
    while (baseDir != null && !File.Exists(Path.Combine(baseDir.FullName, "QuanLyBanTuBepWeb.csproj")))
    {
        baseDir = baseDir.Parent;
    }
    if (baseDir != null && Directory.Exists(Path.Combine(baseDir.FullName, "wwwroot")))
    {
        builder.Environment.ContentRootPath = baseDir.FullName;
        builder.Environment.WebRootPath = Path.Combine(baseDir.FullName, "wwwroot");
    }
}

// 1. Đăng ký DbContext với kết nối SQL Server
builder.Services.AddDbContext<QuanLyBanTuBepContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// 2. Đăng ký Session & Bộ nhớ Cache
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(60);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// 3. Đăng ký Authentication với Cookie
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromDays(7);
        options.SlidingExpiration = true;
    });

// 4. Cho phép truy cập HttpContext trong Views / Services
builder.Services.AddHttpContextAccessor();

// 5. Thêm Controllers và Views
builder.Services.AddControllersWithViews();

var app = builder.Build();

// 6. Cấu hình HTTP Pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
    app.UseHttpsRedirection();
}

// Luôn phục vụ static files từ wwwroot
app.UseStaticFiles();

app.UseRouting();

// Bắt buộc đặt UseSession giữa UseRouting và UseAuthentication/UseAuthorization
app.UseSession();
app.UseAuthentication();
app.UseAuthorization();

// 7. Cấu hình Routing
app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
