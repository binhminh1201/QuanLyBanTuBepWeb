// Tự động nhận diện thư mục dự án chứa wwwroot
string currentDir = Directory.GetCurrentDirectory();
string baseDir = AppContext.BaseDirectory;
string projectDirCandidate = Path.GetFullPath(Path.Combine(baseDir, "..", "..", ".."));

string? contentRoot = null;
if (Directory.Exists(Path.Combine(currentDir, "wwwroot")))
{
    contentRoot = currentDir;
}
else if (Directory.Exists(Path.Combine(projectDirCandidate, "wwwroot")))
{
    contentRoot = projectDirCandidate;
}
else if (Directory.Exists(Path.Combine(baseDir, "wwwroot")))
{
    contentRoot = baseDir;
}

var builder = WebApplication.CreateBuilder(new WebApplicationOptions
{
    Args = args,
    ContentRootPath = contentRoot
});

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

// Chỉ chuyển hướng HTTPS nếu có cấu hình cổng HTTPS để tránh thông báo cảnh báo cổng
if (app.Configuration["HTTPS_PORT"] != null || Environment.GetEnvironmentVariable("ASPNETCORE_HTTPS_PORT") != null)
{
    app.UseHttpsRedirection();
}

app.UseStaticFiles();

app.UseRouting();
app.UseAuthorization();

// Routing mặc định trỏ về Home/Index (Home/Index sẽ chuyển hướng mượt mà sang danh sách sinh viên)
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
