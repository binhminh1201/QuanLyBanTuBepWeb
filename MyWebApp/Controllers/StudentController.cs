using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MyWebApp.Models;

namespace MyWebApp.Controllers
{
    public class StudentController : Controller
    {
        // Danh sách sinh viên mẫu trong bộ nhớ
        private static List<Student> listStudents = new List<Student>();

        public StudentController()
        {
            // Khởi tạo 4 sinh viên mẫu như hướng dẫn trong Lab 1
            if (listStudents.Count == 0)
            {
                listStudents.AddRange(new List<Student>()
                {
                    new Student() { Id = 101, Name = "Hải Nam", Branch = Branch.IT,
                        Gender = Gender.Male, IsRegular = true,
                        Address = "A1-2018", Email = "nam@g.com", DateOfBorth = new DateTime(2003, 1, 1) },
                    new Student() { Id = 102, Name = "Minh Tú", Branch = Branch.BE,
                        Gender = Gender.Female, IsRegular = true,
                        Address = "A1-2019", Email = "tu@g.com", DateOfBorth = new DateTime(2003, 5, 12) },
                    new Student() { Id = 103, Name = "Hoàng Phong", Branch = Branch.CE,
                        Gender = Gender.Male, IsRegular = false,
                        Address = "A1-2020", Email = "phong@g.com", DateOfBorth = new DateTime(2002, 11, 20) },
                    new Student() { Id = 104, Name = "Xuân Mai", Branch = Branch.EE,
                        Gender = Gender.Female, IsRegular = false,
                        Address = "A1-2021", Email = "mai@g.com", DateOfBorth = new DateTime(2004, 3, 8) }
                });
            }
        }

        // Hỗ trợ các route theo quy ước và route tùy biến của Lab 1
        [Route("Student")]
        [Route("Student/Index")]
        [Route("Admin/Student/List")]
        [Route("Students/List")]
        public IActionResult Index()
        {
            return View(listStudents);
        }

        // Cấu hình Route cho Student/Create và mở rộng Admin/Student/Add
        [HttpGet]
        [Route("Student/Create")]
        [Route("Admin/Student/Add")]
        [Route("Students/Add")]
        public IActionResult Create()
        {
            // Lấy danh sách các giá trị Gender để hiển thị radio button trên form
            ViewBag.AllGenders = Enum.GetValues(typeof(Gender)).Cast<Gender>().ToList();

            // Lấy danh sách các giá trị Branch để hiển thị select-option trên form
            ViewBag.AllBranches = new List<SelectListItem>()
            {
                new SelectListItem { Text = "IT", Value = "IT" },
                new SelectListItem { Text = "BE", Value = "BE" },
                new SelectListItem { Text = "CE", Value = "CE" },
                new SelectListItem { Text = "EE", Value = "EE" }
            };

            return View();
        }

        [HttpPost]
        [Route("Student/Create")]
        [Route("Admin/Student/Add")]
        [Route("Students/Add")]
        public async Task<IActionResult> Create(Student s, IFormFile? avatarFile)
        {
            // Xử lý tự sinh ID
            s.Id = (listStudents.Count > 0) ? listStudents.Last().Id + 1 : 101;

            // Xử lý mở rộng upload ảnh đại diện (Mục 9 Lab 1)
            if (avatarFile != null && avatarFile.Length > 0)
            {
                var folderPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "avatars");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }
                var fileName = Guid.NewGuid().ToString() + Path.GetExtension(avatarFile.FileName);
                var filePath = Path.Combine(folderPath, fileName);
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await avatarFile.CopyToAsync(stream);
                }
                s.Avatar = "/images/avatars/" + fileName;
            }

            listStudents.Add(s);

            // Theo Lab 1 trang 4: return View("Index", listStudents);
            return View("Index", listStudents);
        }

        // Xử lý các link menu mẫu từ Lab 2 không bị lỗi 404
        [Route("Branches/List")]
        [Route("Subjects/List")]
        [Route("Courses/List")]
        public IActionResult ComingSoon()
        {
            return RedirectToAction(nameof(Index));
        }
    }
}
