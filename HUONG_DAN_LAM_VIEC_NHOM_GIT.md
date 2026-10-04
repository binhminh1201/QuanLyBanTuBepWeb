# HƯỚNG DẪN LÀM VIỆC NHÓM VỚI GIT & GITHUB (DỰ ÁN QUẢN LÝ BÁN TỦ BẾP)

> **Dành cho các thành viên trong nhóm:** Tài liệu này hướng dẫn cách lấy code về máy, chạy thử và quy trình đẩy code lên GitHub chuẩn để **không bao giờ bị xung đột (conflict) hay đè mất code của nhau**.

---

## PHẦN 1: DÀNH CHO TRƯỞNG NHÓM (CẤP QUYỀN TRUY CẬP)

Để các bạn trong nhóm có quyền sửa và đẩy code lên, bạn (chủ repo) cần cấp quyền như sau:

1. Vào link repo: [https://github.com/binhminh1201/QuanLyBanTuBepWeb](https://github.com/binhminh1201/QuanLyBanTuBepWeb)
2. Bấm vào tab **Settings** (ở thanh menu phía trên).
3. Ở menu bên trái, chọn mục **Collaborators** (có thể GitHub sẽ yêu cầu nhập lại mật khẩu).
4. Bấm nút xanh **Add people**.
5. Nhập **Username** hoặc **Email GitHub** của bạn cùng nhóm $\rightarrow$ Bấm **Add to this repository**.
6. Báo bạn cùng nhóm kiểm tra **Email** hoặc vào thẳng GitHub để bấm **Accept invitation** (Chấp nhận lời mời).

---

## PHẦN 2: THÀNH VIÊN LẦN ĐẦU TẢI DỰ ÁN VỀ MÁY (SETUP)

### 1. Tải code về máy (Clone)
Mở terminal (PowerShell hoặc Git Bash) tại thư mục bạn muốn lưu dự án:
```powershell
git clone https://github.com/binhminh1201/QuanLyBanTuBepWeb.git
cd QuanLyBanTuBepWeb
```

### 2. Cài đặt Cơ sở dữ liệu (SQL Server)
1. Mở **SQL Server Management Studio (SSMS)**.
2. Mở file `QuanLyBanTuBep.sql` nằm trong thư mục gốc vừa tải về.
3. Nhấn **Execute (F5)** để tự động tạo Database, 14 bảng, Trigger và nạp dữ liệu mẫu.

### 3. Cấu hình chuỗi kết nối
Mở file `QuanLyBanTuBepWeb/appsettings.json` và kiểm tra `DefaultConnection` phù hợp với tên SQL Server trên máy bạn:
* Nếu dùng LocalDB (Visual Studio): `(localdb)\\MSSQLLocalDB`
* Nếu dùng SQL Express: `.\\SQLEXPRESS` hoặc `localhost`

---

## PHẦN 3: QUY TRÌNH LÀM VIỆC HÀNG NGÀY (CỰC KỲ QUAN TRỌNG ⚠️)

> **NGUYÊN TẮC VÀNG:** 
> 1. Không bao giờ code trực tiếp trên nhánh `main`.
> 2. Luôn kéo code mới nhất về trước khi bắt đầu làm (`git pull`).
> 3. Mỗi người tạo một nhánh riêng để làm tính năng của mình (`git checkout -b <ten-nhanh>`).

---

### Bước 1: Trước khi bắt đầu viết code (Lấy code mới nhất)
```powershell
# Chuyển về nhánh main
git checkout main

# Kéo toàn bộ code mới nhất của nhóm về
git pull origin main
```

---

### Bước 2: Tạo nhánh riêng cho công việc của bạn
Đặt tên nhánh theo cú pháp: `feature/<ten-ban>-<chuc-nang>` hoặc `<ten-ban>/<chuc-nang>`
* Ví dụ:
  * Bạn Nam làm quản lý nhân viên: `git checkout -b nam/quan-ly-nhan-vien`
  * Bạn Hoa làm thống kê doanh thu: `git checkout -b hoa/thong-ke`
  * Bạn sửa giao diện giỏ hàng: `git checkout -b minh/sua-gio-hang`

```powershell
# Tạo và chuyển sang nhánh mới
git checkout -b ten-cua-ban/ten-tinh-nang
```

---

### Bước 3: Viết code và Lưu lại (Commit)
Sau khi code và test chạy thử ổn định trên máy cá nhân:
```powershell
# 1. Kiểm tra những file mình đã sửa
git status

# 2. Thêm các file thay đổi vào git
git add .

# 3. Ghi chú rõ ràng mình vừa sửa/thêm cái gì
git commit -m "Hoan thanh chuc nang tim kiem nang cao san pham"
```

---

### Bước 4: Đẩy nhánh của mình lên GitHub
```powershell
git push -u origin ten-cua-ban/ten-tinh-nang
```

---

### Bước 5: Ghép code vào nhánh chính (Tạo Pull Request - PR)

1. Lên trang GitHub [binhminh1201/QuanLyBanTuBepWeb](https://github.com/binhminh1201/QuanLyBanTuBepWeb).
2. Bạn sẽ thấy một thanh thông báo màu vàng hiện lên kèm nút **Compare & pull request** $\rightarrow$ Bấm vào đó.
3. Viết mô tả ngắn những gì bạn vừa làm:
   * *Ví dụ: "Đã làm xong view danh sách nhân viên và thêm validation cho form"*.
4. Bấm **Create pull request**.
5. **Trưởng nhóm (hoặc bạn khác)** vào review xem code có bị lỗi gì không, sau đó bấm nút xanh **Merge pull request** $\rightarrow$ **Confirm merge**.
6. Vậy là code mới đã được nhập an toàn vào nhánh `main` mà không sợ đè code của ai!

---

## PHẦN 4: BẢNG TRA CỨU NHANH CÁC LỆNH HAY DÙNG

| Lệnh | Ý nghĩa |
| :--- | :--- |
| `git status` | Xem trạng thái các file đang sửa |
| `git branch` | Xem mình đang đứng ở nhánh nào |
| `git checkout main` | Quay về nhánh chính `main` |
| `git pull origin main` | Cập nhật code mới nhất từ GitHub về máy |
| `git checkout -b <ten-nhanh>` | Tạo nhánh mới và nhảy sang nhánh đó |
| `git add .` | Chuẩn bị commit tất cả file đã sửa |
| `git commit -m "noi dung"` | Lưu lại phiên bản với lời nhắn |
| `git push -u origin <ten-nhanh>` | Đẩy nhánh của mình lên GitHub |
