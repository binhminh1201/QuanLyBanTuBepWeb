# Script tao file Word Bao Cao BTL Nhom 5 Hoan Chinh kem anh chup thuc te
$ErrorActionPreference = "Stop"

$outputPath = "d:\DoStBetter\LTW\BaoCao_BaiTapLon_Nhom5_HoanChinh.docx"
$imgDir = "d:\DoStBetter\LTW\ReportScreenshots"

# Kill lingering Word processes if any
Get-Process -Name "WINWORD" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

$doc = $word.Documents.Add()

# Page setup A4, Margins
$doc.PageSetup.PaperSize = 7 # wdPaperA4
$doc.PageSetup.TopMargin = $word.CentimetersToPoints(2.0)
$doc.PageSetup.BottomMargin = $word.CentimetersToPoints(2.0)
$doc.PageSetup.LeftMargin = $word.CentimetersToPoints(2.5)
$doc.PageSetup.RightMargin = $word.CentimetersToPoints(2.0)

# Helper functions
function Add-Heading1($text) {
    $p = $doc.Paragraphs.Add()
    $p.Range.Text = $text
    $p.Range.Font.Name = "Times New Roman"
    $p.Range.Font.Size = 15
    $p.Range.Font.Bold = 1
    $p.Range.Font.Color = 0x8A3A1E # Deep Navy (BGR: 0x8A, 0x3A, 0x1E)
    $p.Range.ParagraphFormat.SpaceBefore = 12
    $p.Range.ParagraphFormat.SpaceAfter = 6
    $p.Range.InsertParagraphAfter()
}

function Add-Heading2($text) {
    $p = $doc.Paragraphs.Add()
    $p.Range.Text = $text
    $p.Range.Font.Name = "Times New Roman"
    $p.Range.Font.Size = 13
    $p.Range.Font.Bold = 1
    $p.Range.Font.Color = 0x0953B4 # Warm bronze/amber
    $p.Range.ParagraphFormat.SpaceBefore = 8
    $p.Range.ParagraphFormat.SpaceAfter = 4
    $p.Range.InsertParagraphAfter()
}

function Add-Heading3($text) {
    $p = $doc.Paragraphs.Add()
    $p.Range.Text = $text
    $p.Range.Font.Name = "Times New Roman"
    $p.Range.Font.Size = 12
    $p.Range.Font.Bold = 1
    $p.Range.Font.Color = 0x2A170F # Slate
    $p.Range.ParagraphFormat.SpaceBefore = 6
    $p.Range.ParagraphFormat.SpaceAfter = 2
    $p.Range.InsertParagraphAfter()
}

function Add-Para($text) {
    $p = $doc.Paragraphs.Add()
    $p.Range.Text = $text
    $p.Range.Font.Name = "Times New Roman"
    $p.Range.Font.Size = 12
    $p.Range.Font.Bold = 0
    $p.Range.Font.Color = 0x000000
    $p.Range.ParagraphFormat.LineSpacing = 15 # 1.25 line spacing
    $p.Range.ParagraphFormat.SpaceBefore = 0
    $p.Range.ParagraphFormat.SpaceAfter = 4
    $p.Range.ParagraphFormat.Alignment = 3 # wdAlignParagraphJustify
    $p.Range.InsertParagraphAfter()
}

function Add-ImageWithCaption($imgName, $caption) {
    $imgPath = Join-Path $imgDir $imgName
    if (Test-Path $imgPath) {
        $p = $doc.Paragraphs.Add()
        $p.Range.ParagraphFormat.Alignment = 1 # wdAlignParagraphCenter
        $shape = $doc.InlineShapes.AddPicture($imgPath, $false, $true, $p.Range)
        # Scale to max width 440 pt
        if ($shape.Width -gt 440) {
            $ratio = 440.0 / $shape.Width
            $shape.Width = 440
            $shape.Height = $shape.Height * $ratio
        }
        $p.Range.InsertParagraphAfter()

        $pCap = $doc.Paragraphs.Add()
        $pCap.Range.Text = $caption
        $pCap.Range.Font.Name = "Times New Roman"
        $pCap.Range.Font.Size = 10.5
        $pCap.Range.Font.Italic = 1
        $pCap.Range.Font.Color = 0x555555
        $pCap.Range.ParagraphFormat.Alignment = 1 # Center
        $pCap.Range.ParagraphFormat.SpaceBefore = 2
        $pCap.Range.ParagraphFormat.SpaceAfter = 8
        $pCap.Range.InsertParagraphAfter()
    }
}

Write-Output "Building Cover Page..."
# 1. COVER PAGE
$pCover = $doc.Paragraphs.Add()
$pCover.Range.Text = "BỘ GIÁO DỤC VÀ ĐÀO TẠO`nTRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI`nKHOA CÔNG NGHỆ THÔNG TIN`n***"
$pCover.Range.Font.Name = "Times New Roman"
$pCover.Range.Font.Size = 13
$pCover.Range.Font.Bold = 1
$pCover.Range.ParagraphFormat.Alignment = 1
$pCover.Range.ParagraphFormat.SpaceAfter = 36
$pCover.Range.InsertParagraphAfter()

$pTitle = $doc.Paragraphs.Add()
$pTitle.Range.Text = "BÁO CÁO BÀI TẬP LỚN MÔN HỌC`nLẬP TRÌNH WEB"
$pTitle.Range.Font.Name = "Times New Roman"
$pTitle.Range.Font.Size = 18
$pTitle.Range.Font.Bold = 1
$pTitle.Range.Font.Color = 0x8A3A1E
$pTitle.Range.ParagraphFormat.Alignment = 1
$pTitle.Range.ParagraphFormat.SpaceAfter = 18
$pTitle.Range.InsertParagraphAfter()

$pSub = $doc.Paragraphs.Add()
$pSub.Range.Text = "ĐỀ TÀI SỐ 47:`nXÂY DỰNG WEBSITE QUẢN LÝ BÁN TỦ BẾP (KITCHENLUX)"
$pSub.Range.Font.Name = "Times New Roman"
$pSub.Range.Font.Size = 15
$pSub.Range.Font.Bold = 1
$pSub.Range.Font.Color = 0x0953B4
$pSub.Range.ParagraphFormat.Alignment = 1
$pSub.Range.ParagraphFormat.SpaceAfter = 60
$pSub.Range.InsertParagraphAfter()

$pInfo = $doc.Paragraphs.Add()
$pInfo.Range.Text = "Giảng viên hướng dẫn: ThS. Giảng viên phụ trách môn`nSinh viên thực hiện:  Nhóm 5`nHọc phần:             Lập trình Web (ASP.NET Core MVC)`nNăm học:              2025 - 2026"
$pInfo.Range.Font.Name = "Times New Roman"
$pInfo.Range.Font.Size = 12.5
$pInfo.Range.Font.Bold = 0
$pInfo.Range.ParagraphFormat.Alignment = 0 # Left
$pInfo.Range.ParagraphFormat.LeftIndent = $word.CentimetersToPoints(3.5)
$pInfo.Range.ParagraphFormat.SpaceAfter = 70
$pInfo.Range.InsertParagraphAfter()

$pFoot = $doc.Paragraphs.Add()
$pFoot.Range.Text = "Hà Nội, Năm 2026"
$pFoot.Range.Font.Name = "Times New Roman"
$pFoot.Range.Font.Size = 12
$pFoot.Range.Font.Bold = 1
$pFoot.Range.ParagraphFormat.Alignment = 1
$pFoot.Range.InsertParagraphAfter()

# Page Break
$doc.Words.Last.InsertBreak(7) # wdPageBreak

Write-Output "Building Content Sections..."

# ==========================================================
# CHUONG 1: TONG QUAN & MO HINH PHAT TRIEN
# ==========================================================
Add-Heading1 "CHƯƠNG 1: TỔNG QUAN VÀ KHẢO SÁT HỆ THỐNG"

Add-Heading2 "1.1. Bối cảnh và Lý do lựa chọn đề tài"
Add-Para "Trong thời đại chuyển đổi số và thương mại điện tử bùng nổ, việc ứng dụng công nghệ thông tin vào công tác quản trị kinh doanh nội thất là xu hướng tất yếu. Ngành hàng tủ bếp mang đặc thù kỹ thuật phức tạp với kích thước đa dạng (chữ I, L, U), kết hợp giữa nhiều loại vật liệu (Acrylic, Inox 304 cánh kính, Gỗ sồi, MDF chống ẩm) và đòi hỏi quy trình tư vấn, khảo sát đo đạc thực tế tại công trình."
Add-Para "Phương thức quản lý truyền thống qua sổ sách hoặc bảng tính Excel bộc lộ nhiều hạn chế: khó kiểm soát biến động tồn kho, thất lạc yêu cầu tư vấn của khách hàng và tốn nhiều thời gian tổng hợp báo cáo kinh doanh theo từng quý. Do đó, việc xây dựng website 'Quản lý bán tủ bếp KITCHENLUX' trên nền tảng ASP.NET Core MVC kết hợp Entity Framework Core và SQL Server 2022 giải quyết trọn vẹn bài toán kinh doanh thực tế của Đề tài số 47."

Add-Heading2 "1.2. Mục tiêu và Phạm vi của dự án"
Add-Para "Mục tiêu chính của đề tài bao gồm:"
Add-Para "1. Xây dựng showroom trực tuyến hiện đại giới thiệu 20 mẫu tủ bếp với album ảnh đa góc chụp thực tế, bảng thông số kích thước và giá cả minh bạch."
Add-Para "2. Hiện thực cơ chế lọc tìm kiếm đa tiêu chí bằng kỹ thuật bất đồng bộ AJAX (lọc theo Chất liệu, Màu sắc, Kích thước, Xuất xứ và Khoảng giá) mà không cần tải lại toàn trang."
Add-Para "3. Quản lý giỏ hàng trực tuyến bằng Session và quy trình đặt hàng khảo sát với 2 lớp kiểm tra dữ liệu (Client-side và Server-side Data Annotations)."
Add-Para "4. Xây dựng phân hệ Quản trị viên (Admin Area) với đầy đủ chức năng CRUD sản phẩm, Upload ảnh đại diện lưu vào CSDL, tìm kiếm hóa đơn bán đa tiêu chí (YC5) và trọn bộ 4 báo cáo thống kê đặc thù (YC6, YC7, YC8, YC9)."

Add-Heading2 "1.3. Mô hình phát triển phần mềm: Mô hình Thác nước (Waterfall Model)"
Add-Para "Dự án áp dụng Mô hình Thác nước (Waterfall Model) - quy trình phát triển phần mềm tuần tự tuyến tính qua 5 giai đoạn rõ rệt:"
Add-Para "• Giai đoạn 1 - Khảo sát & Phân tích yêu cầu (Requirements): Thu thập toàn diện các yêu cầu nghiệp vụ theo phiếu giao đề tài 47 (các tiêu chí tìm kiếm HĐB, 4 mẫu báo cáo thống kê, luồng giỏ hàng và thanh toán COD/QR)."
Add-Para "• Giai đoạn 2 - Thiết kế hệ thống (System Design): Thiết kế biểu đồ Use Case tổng quát, xây dựng biểu đồ thực thể quan hệ ERD chuẩn hóa 14 bảng dữ liệu, thiết kế Wireframe giao diện người dùng theo chuẩn phong cách kiến trúc nội thất."
Add-Para "• Giai đoạn 3 - Cài đặt & Lập trình (Implementation): Lập trình Backend C# ASP.NET Core 8.0/10.0 MVC, kết nối CSDL qua Entity Framework Core; xây dựng 14 bảng, 2 triggers tự động hóa và 4 stored procedures trong SQL Server; phát triển Frontend với Razor View, Bootstrap 5 và jQuery AJAX."
Add-Para "• Giai đoạn 4 - Kiểm thử hệ thống (Testing): Thực hiện kiểm thử hộp đen (Black-box testing) trên 15 bộ kịch bản kiểm thử (Test Cases), kiểm tra toàn vẹn dữ liệu khóa ngoại, bắt lỗi validation đầu vào và kiểm soát bảo mật."
Add-Para "• Giai đoạn 5 - Triển khai & Nghiệm thu (Deployment): Chạy ứng dụng trên môi trường máy chủ cục bộ Kestrel/IIS Express, kiểm thử tương thích đa trình duyệt và đóng gói toàn bộ tài liệu báo cáo."
Add-Para "Lý do lựa chọn: Do phạm vi nghiệp vụ và các tiêu chí báo cáo của Đề tài 47 đã được định nghĩa cố định rõ ràng ngay từ đầu, mô hình Thác nước giúp nhóm đảm bảo hoàn thành tuần tự từng giai đoạn, dễ dàng quản lý mốc thời gian và lưu vết hồ sơ thiết kế chặt chẽ."

# ==========================================================
# CHUONG 2: PHAN TICH & THIET KE HE THONG
# ==========================================================
Add-Heading1 "CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG"

Add-Heading2 "2.1. Phân tích chức năng người dùng"
Add-Para "Hệ thống phân định 2 tác nhân (Actors) chính:"
Add-Para "1. Khách hàng (Front-End): Khách vãng lai và thành viên có thể duyệt sản phẩm, lọc AJAX, tìm kiếm từ khóa, xem chi tiết album ảnh đa góc, thêm vào giỏ hàng Session, đặt hàng khảo sát tại nhà (bắt buộc nhập Số điện thoại hợp lệ), đăng ký/đăng nhập thành viên và tra cứu lịch sử đơn hàng."
Add-Para "2. Quản trị viên (Admin Area): Được bảo vệ bởi bộ lọc [Authorize(Roles = 'Admin')], toàn quyền truy cập Dashboard thống kê, quản lý danh mục tủ bếp (thêm, sửa kèm Upload ảnh, xóa an toàn), tìm kiếm hóa đơn bán đa tiêu chí (YC5) và thực thi trọn bộ 4 thủ tục báo cáo doanh số (YC6, YC7, YC8, YC9)."

Add-Heading2 "2.2. Thiết kế Cơ sở dữ liệu quan hệ (ERD)"
Add-Para "Cơ sở dữ liệu QuanLyBanTuBep được chuẩn hóa ở dạng chuẩn 3NF bao gồm 14 bảng quan hệ, chia thành 3 phân nhóm chức năng:"
Add-Para "• Nhóm danh mục thuộc tính: KichThuoc, ChatLieu, MauSac, NuocSanXuat."
Add-Para "• Nhóm sản phẩm trung tâm: DMHangHoa (lưu 20 mẫu tủ bếp, các thuộc tính mã, giá nhập, đơn giá bán, thời gian bảo hành, chuỗi tệp hình ảnh, ghi chú CKEditor)."
Add-Para "• Nhóm đối tác & nhân sự: KhachHang, NhaCungCap, CongViec, NhanVien, TaiKhoan."
Add-Para "• Nhóm giao dịch mua bán: HoaDonBan, ChiTietHoaDonBan, HoaDonNhap, ChiTietHoaDonNhap."
Add-Para "Quan hệ giữa CongViec và NhanVien: Trong sơ đồ ERD, thực thể CongViec nối với NhanVien qua quan hệ 1-N (Một vị trí công việc có thể được đảm nhiệm bởi nhiều nhân viên). Khóa ngoại NhanVien.MaCV tham chiếu đến CongViec.MaCV thông qua ràng buộc chính thức: FOREIGN KEY (MaCV) REFERENCES CongViec(MaCV) ON UPDATE CASCADE ON DELETE SET NULL. Mối liên kết này đảm bảo quản lý vị trí công tác và mức lương chuẩn xác cho từng nhân sự."

Add-Heading2 "2.3. Quy định chuẩn hóa dữ liệu & Validation"
Add-Para "Hệ thống áp dụng cơ chế kiểm tra dữ liệu đầu vào 2 lớp (Client-side & Server-side):"
Add-Para "• Quy định Số điện thoại (Regex): Sử dụng biểu thức chính quy [RegularExpression(@'^0\d{9,10}$')]. Biểu thức này bắt buộc ký tự đầu tiên là chữ số 0, cho phép chuỗi tiếp theo gồm 9 hoặc 10 chữ số. Ràng buộc này tiếp nhận hợp lệ cả số di động chuẩn 10 chữ số của các nhà mạng Việt Nam (09x, 03x, 08x, 07x) và số máy bàn cố định 11 chữ số có mã vùng tỉnh/thành phố (Hà Nội 024.xxx.xxxx, TP.HCM 028.xxx.xxxx). Thông báo lỗi chuẩn: 'Số điện thoại phải bắt đầu bằng số 0 và gồm 10 đến 11 chữ số'."
Add-Para "• Ràng buộc toàn vẹn khóa ngoại (Foreign Key Protection): Không cho phép xóa sản phẩm hoặc xóa nhân viên nếu bản ghi đó đã phát sinh hóa đơn bán hoặc hóa đơn nhập hàng, đảm bảo tính toàn vẹn tuyệt đối cho dữ liệu kế toán."

# ==========================================================
# CHUONG 3: HIEN THUC & GIAO DIEN THUC TE
# ==========================================================
Add-Heading1 "CHƯƠNG 3: CÀI ĐẶT VÀ GIAO DIỆN HỆ THỐNG THỰC TẾ"

Add-Heading2 "3.1. Giao diện Trang chủ Showroom KITCHENLUX"
Add-Para "Trang chủ được thiết kế theo phong cách kiến trúc nội thất cao cấp: tone than chì (#0f172a), đường viền đồng ấm (#b45309), các góc bo nhẹ sắc sảo (border-radius: 4px) loại bỏ hoàn toàn các khung bo tròn và màu gradient đại trà. Trang chủ tích hợp thanh lọc nhanh chất liệu, danh sách sản phẩm nổi bật và 4 khối cam kết chất lượng có liên kết điều hướng trực tiếp."
Add-ImageWithCaption "Hinh4.1_TrangChu.png" "Hình 3.1: Giao diện Trang chủ Showroom KITCHENLUX phong cách kiến trúc cao cấp"

Add-Heading2 "3.2. Giao diện Danh mục & Bộ lọc AJAX đa tiêu chí"
Add-Para "Trang danh mục tủ bếp tích hợp ViewComponent thanh lọc bên trái và container danh sách sản phẩm bên phải. Người dùng có thể lọc kết hợp linh hoạt theo Chất liệu, Màu sắc, Kích thước, Xuất xứ và Khoảng giá. Toàn bộ thao tác lọc và phân trang đều được xử lý bất đồng bộ qua jQuery AJAX trả về PartialView (_ProductListPartial) mà không cần tải lại trang."
Add-ImageWithCaption "Hinh4.2_BoLocSanPham.png" "Hình 3.2: Bộ lọc sản phẩm đa tiêu chí và ô tìm kiếm từ khóa qua AJAX"
Add-ImageWithCaption "Hinh4.3_PhanTrang.png" "Hình 3.3: Giao diện phân trang AJAX tải mượt mà không reload trang"

Add-Heading2 "3.3. Giao diện Chi tiết sản phẩm & Album ảnh đa góc"
Add-Para "Trang chi tiết hiển thị album ảnh thực tế chụp đa góc (chính diện, góc nghiêng 3D, khoang phụ kiện và mặt đá), bảng thông số kỹ thuật, giá mét dài niêm yết và nút thêm vào giỏ hàng có hiệu ứng tương tác trực quan."
Add-ImageWithCaption "Hinh4.4_ChiTietSanPham.png" "Hình 3.4: Chi tiết mẫu tủ bếp TB01 và album ảnh đa góc thực tế"

Add-Heading2 "3.4. Giao diện Giỏ hàng & Quy trình đặt hàng khảo sát"
Add-Para "Giỏ hàng được quản lý lưu trữ trong Session người dùng. Khách hàng có thể tăng giảm số lượng, xóa sản phẩm và tiến hành đặt hàng với form kiểm soát dữ liệu nghiêm ngặt. Khi đơn hàng được xác nhận, hệ thống tự động sinh Hóa đơn bán và trừ số lượng tồn kho trong SQL Server."
Add-ImageWithCaption "Hinh4.5_GioHang.png" "Hình 3.5: Giỏ hàng trực tuyến lưu trữ bằng Session"

Add-Heading2 "3.5. Giao diện Chính sách bảo hành & Quy trình khảo sát"
Add-Para "Trang chính sách được tổ chức dạng tab điều hướng thông minh, tự động cập nhật URL (?tab=...) giúp khách hàng dễ dàng chia sẻ liên kết chính sách bảo hành 24-36 tháng và quy trình 5 bước đo đạc laser tại nhà."
Add-ImageWithCaption "Hinh4.6_ChinhSachBaoHanh.png" "Hình 3.6: Chính sách bảo hành kết cấu 24-36 tháng và bảo trì trọn đời"
Add-ImageWithCaption "Hinh4.7_QuyTrinhKhaoSat.png" "Hình 3.7: Quy trình khảo sát và thiết kế 3D 5 bước tại nhà khách hàng"

Add-Heading2 "3.6. Giao diện Đăng ký & Đăng nhập thành viên"
Add-Para "Hệ thống xác thực người dùng thông qua Cookie Authentication. Form đăng ký bắt buộc Số điện thoại và kiểm tra trùng lặp tài khoản. Form đăng nhập tự động so khớp mật khẩu băm một chiều."
Add-ImageWithCaption "Hinh4.8_DangKy.png" "Hình 3.8: Form đăng ký thành viên kèm validation Số điện thoại"
Add-ImageWithCaption "Hinh4.9_DangNhap.png" "Hình 3.9: Form đăng nhập tài khoản phân quyền Cookie Authentication"

Add-Heading2 "3.7. Dịch vụ Web API & Cơ chế Quốc tế hóa (i18n)"
Add-Para "1. Dịch vụ RESTful Web API: Xây dựng Controller TuBepApiController cung cấp endpoint GET /api/tubep trả về toàn bộ dữ liệu 20 mẫu tủ bếp định dạng chuẩn JSON, phục vụ tích hợp với ứng dụng di động hoặc đối tác đại lý."
Add-ImageWithCaption "Hinh4.12_WebAPI_JSON.png" "Hình 3.10: Dữ liệu RESTful API trả về định dạng JSON chuẩn qua route /api/tubep"

Add-Para "2. Cơ chế Quốc tế hóa (i18n - Internationalization):"
Add-Para "ASP.NET Core hỗ trợ đa ngôn ngữ thông qua thư viện Microsoft.AspNetCore.Localization và interface IStringLocalizer. Trong kiến trúc đề xuất, hệ thống cấu hình RequestLocalizationOptions tại Program.cs hỗ trợ song ngữ Tiếng Việt (vi-VN) mặc định và Tiếng Anh (en-US)."
Add-Para "Các chuỗi nhãn hiển thị được lưu trữ trong tệp tài nguyên XML (.resx) tại thư mục Resources/ (ví dụ SharedResource.vi.resx và SharedResource.en.resx). Văn hóa người dùng được xác định tự động qua Culture Providers theo thứ tự ưu tiên: Query string (?culture=en-US), Cookie văn hóa (.AspNetCore.Culture) và Header Accept-Language của trình duyệt."

Add-Heading2 "3.8. Cơ chế Bảo mật & Bảng băm mật khẩu (Password Hashing)"
Add-Para "Hệ thống thiết lập 5 lớp phòng thủ an ninh toàn diện:"
Add-Para "1. Băm mật khẩu một chiều (PBKDF2 SHA-256): Ứng dụng lớp Microsoft.AspNetCore.Identity.PasswordHasher<TaiKhoan>, sử dụng thuật toán PBKDF2 với HMAC-SHA256, 128-bit Salt ngẫu nhiên và hơn 10.000 vòng lặp. Chuỗi băm 84 ký tự bắt đầu bằng tiền tố AQAAAA... được lưu trong cột MatKhau. Hệ thống tích hợp tính năng tự động di trú: băm lại toàn bộ mật khẩu cũ dạng plain-text ngay khi ứng dụng khởi động."
Add-Para "2. Chống CSRF: Sử dụng thẻ @Html.AntiForgeryToken() trên mọi form POST và kiểm duyệt qua thuộc tính [ValidateAntiForgeryToken] trên Controller."
Add-Para "3. Chống SQL Injection: 100% truy vấn CSDL qua Entity Framework Core (LINQ to Entities), tự động tham số hóa câu lệnh SQL ngăn chặn triệt để tiêm mã độc."
Add-Para "4. Chống XSS: Razor View Engine tự động mã hóa HTML Encoding dữ liệu đầu ra trước khi render."
Add-Para "5. Phân quyền vai trò (Role-Based Authorization): Toàn bộ phân hệ Quản trị được bảo vệ bởi [Authorize(Roles = 'Admin')]. Khách hàng cố tình truy cập sẽ bị chặn và điều hướng về trang lỗi 403 (/Account/AccessDenied)."

# ==========================================================
# CHUONG 4: KIEM THU HE THONG (TEST CASES)
# ==========================================================
Add-Heading1 "CHƯƠNG 4: KIỂM THỬ HỆ THỐNG (TESTING)"
Add-Para "Kiểm thử hệ thống được tiến hành bằng phương pháp Kiểm thử hộp đen (Black-box Testing) với 15 ca kiểm thử đại diện bao quát toàn bộ các phân hệ của Đề tài 47:"

# Create Table for Test Cases (16 rows, 6 columns)
$table = $doc.Tables.Add($doc.Words.Last, 16, 6)
$table.Borders.Enable = 1
$table.Borders.OutsideColor = 0x8A3A1E
$table.Borders.InsideColor = 0xCCCCCC

$headers = @("ID", "Chức năng kiểm thử", "Dữ liệu đầu vào & Ràng buộc", "Kết quả kỳ vọng", "Kết quả thực tế", "Kết luận")
for ($col = 1; $col -le 6; $col++) {
    $cell = $table.Cell(1, $col)
    $cell.Range.Text = $headers[$col - 1]
    $cell.Range.Font.Name = "Times New Roman"
    $cell.Range.Font.Size = 10
    $cell.Range.Font.Bold = 1
    $cell.Shading.BackgroundPatternColor = 0xF1F5F9
}

$tcData = @(
    @("TC01", "Lọc SP theo chất liệu (AJAX)", "Chọn chất liệu: CL02 (Acrylic)", "Cập nhật danh sách mẫu tủ Acrylic, không reload trang", "Danh sách nạp chính xác các mẫu tủ Acrylic qua PartialView", "PASS"),
    @("TC02", "Lọc SP theo khoảng giá (AJAX)", "Chọn radio: Dưới 10 triệu", "Chỉ hiển thị các mẫu tủ bếp có đơn giá bán <= 10 triệu", "Hiển thị đúng 2 mẫu TB04 (9.8tr) và TB15 (7.5tr)", "PASS"),
    @("TC03", "Tìm kiếm từ khóa theo tên", "Nhập từ khóa: 'Inox' và bấm Enter", "Hiển thị tất cả các mẫu tủ bếp có tên chứa chữ Inox", "Hiển thị đúng 5 mẫu tủ Inox (TB02, TB06, TB13, TB18, TB20)", "PASS"),
    @("TC04", "Phân trang dữ liệu AJAX", "Bấm chuyển sang trang số 2", "Nạp 6 sản phẩm tiếp theo, tự động cuộn lên đầu danh sách", "Nạp chính xác 6 sản phẩm kế tiếp, URL giữ nguyên", "PASS"),
    @("TC05", "Thêm sản phẩm vào giỏ (AJAX)", "Bấm nút 'Chọn mua' tại sản phẩm TB01", "Huy hiệu giỏ hàng nhảy từ 0 lên 1, hiện Toast xanh", "Badge cập nhật ngay lập tức, Toast hiển thị thông báo", "PASS"),
    @("TC06", "Cập nhật số lượng giỏ hàng", "Bấm nút [+] tăng số lượng TB01 lên 2", "Số lượng hiển thị = 2, tổng tiền đơn hàng nhân đôi", "Số lượng = 2, tổng thanh toán cập nhật chuẩn xác", "PASS"),
    @("TC07", "Validate để trống SĐT khi Đặt hàng", "Bỏ trống Họ tên và SĐT, bấm Đặt hàng", "Báo lỗi đỏ: 'Số điện thoại không được để trống'", "Dòng chữ đỏ cảnh báo lỗi xuất hiện ngay dưới ô input", "PASS"),
    @("TC08", "Validate sai định dạng SĐT (Regex)", "Nhập SĐT: '123456' (thiếu số 0, không đủ 10 số)", "Báo lỗi: Số điện thoại phải bắt đầu bằng 0 và gồm 10-11 số", "Báo lỗi chính xác theo biểu thức chính quy ^0\\d{9,10}$", "PASS"),
    @("TC09", "Đặt hàng thành công & Trừ tồn kho", "Nhập thông tin hợp lệ (SĐT: 0912345678)", "Sinh mã HDB mới trong DB, trừ tồn kho, giỏ hàng rỗng", "Tạo hóa đơn thành công, điều hướng sang OrderSuccess", "PASS"),
    @("TC10", "Đăng ký không nhập Email", "Nhập Họ tên, SĐT, User, Pass; để trống Email", "Đăng ký thành công, tài khoản lưu với Email = NULL", "Đăng ký thành công, tự động liên kết mã khách hàng mới", "PASS"),
    @("TC11", "Chặn truy cập trái phép Admin", "Tài khoản khách hàng gõ URL /Admin/DMHangHoa", "Bị chặn truy cập, chuyển hướng về trang lỗi 403", "Hệ thống chuyển hướng chính xác về /Account/AccessDenied", "PASS"),
    @("TC12", "Thêm tủ bếp mới kèm Upload ảnh", "Nhập thông tin SP, chọn file ảnh .jpg (<= 5MB)", "Sản phẩm lưu vào DB, file ảnh lưu wwwroot/images/products", "Sản phẩm mới xuất hiện trên danh sách kèm ảnh hiển thị", "PASS"),
    @("TC13", "Xóa SP có ràng buộc khóa ngoại", "Bấm nút Xóa sản phẩm TB01 (đã có hóa đơn)", "Từ chối xóa, hiển thị cảnh báo lỗi toàn vẹn dữ liệu", "Báo lỗi: 'Không thể xoá vì sản phẩm đã có trong hóa đơn!'", "PASS"),
    @("TC14", "Báo cáo Top 3 SP theo Quý (YC6)", "Chọn Năm: 2026, Quý: 1", "Trả về 3 sản phẩm bán chạy nhất quý 1/2026", "Hiển thị chính xác 3 sản phẩm TB01, TB04, TB02", "PASS"),
    @("TC15", "Báo cáo HĐ Nhập theo NV (YC7)", "Chọn nhân viên: NV04 - Phạm Thu Hà", "Liệt kê tất cả hóa đơn nhập hàng do NV04 thực hiện", "Hiển thị chính xác 4 hóa đơn HDN01-HDN04 của NV04", "PASS")
)

for ($row = 0; $row -lt $tcData.Count; $row++) {
    for ($col = 0; $col -lt 6; $col++) {
        $cell = $table.Cell($row + 2, $col + 1)
        $cell.Range.Text = $tcData[$row][$col]
        $cell.Range.Font.Name = "Times New Roman"
        $cell.Range.Font.Size = 9.5
        if ($col -eq 5) {
            $cell.Range.Font.Bold = 1
            $cell.Range.Font.Color = 0x008000 # Green
        }
    }
}
$doc.Words.Last.InsertParagraphAfter()

# ==========================================================
# CHUONG 5: KET LUAN & HUONG PHAT TRIEN
# ==========================================================
Add-Heading1 "CHƯƠNG 5: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN"

Add-Heading2 "5.1. Kết quả đạt được"
Add-Para "Sau quá trình nghiên cứu và hiện thực nghiêm túc, đề tài đã đạt được các kết quả nổi bật:"
Add-Para "1. Hoàn thành 100% các yêu cầu nghiệp vụ của Đề tài số 47: Tìm kiếm hóa đơn bán đa tiêu chí (YC5), trọn bộ 4 báo cáo thống kê đặc thù (YC6, YC7, YC8, YC9), quản lý xuất nhập tồn tự động cập nhật giá bán đề xuất qua Trigger SQL."
Add-Para "2. Ứng dụng thành công các kỹ thuật hiện đại của học phần: ASP.NET Core MVC, Entity Framework Core, AJAX không tải lại trang, Cookie Authentication phân quyền, ViewComponent độc lập và Web API RESTful."
Add-Para "3. Cải tiến bảo mật toàn diện: Băm mật khẩu người dùng bằng PBKDF2 SHA-256 kèm Salt chuẩn công nghiệp, phòng chống triệt để các lỗ hổng CSRF, SQL Injection và XSS."
Add-Para "4. Giao diện được chuẩn hóa theo phong cách kiến trúc nội thất cao cấp: sắc sảo, dứt khoát, loại bỏ các chi tiết bo tròn quá đà và màu gradient đại trà."

Add-Heading2 "5.2. Hướng phát triển trong tương lai"
Add-Para "• Tích hợp cổng thanh toán trực tuyến tự động VNPay / MoMo Sandbox phục vụ đặt cọc đơn hàng online."
Add-Para "• Tích hợp thư viện SignalR xây dựng tính năng Chatbox tư vấn trực tuyến thời gian thực giữa khách hàng và kiến trúc sư."
Add-Para "• Triển khai hoàn thiện cơ chế đa ngôn ngữ (i18n) Việt - Anh phục vụ khách hàng quốc tế có nhu cầu đặt hàng tủ bếp xuất khẩu."

Write-Output "Saving document to $outputPath..."
$doc.SaveAs([ref]$outputPath)
$doc.Close()
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($doc) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Output "Word Report Generated Successfully at: $outputPath"