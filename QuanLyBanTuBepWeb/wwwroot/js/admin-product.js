// ============================================================================
// admin-product.js - Xử lý tự động tính giá bán (110%), xem trước ảnh & modal xóa
// ============================================================================

$(document).ready(function () {
    // 1. Tự động tính Đơn giá bán = 110% Giá nhập khi nhập liệu
    $("#inputGiaNhap").on("input", function () {
        var giaNhap = parseFloat($(this).val()) || 0;
        if (giaNhap > 0) {
            var giaBan = Math.round(giaNhap * 1.10);
            $("#inputDonGiaBan").val(giaBan);
        }
    });

    // 2. Xem trước ảnh tải lên (Form Thêm mới)
    var fileUploadCreate = document.getElementById("fileUploadInput");
    if (fileUploadCreate) {
        fileUploadCreate.addEventListener("change", function (e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    document.getElementById("imagePreview").src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    }

    // 3. Xem trước ảnh mới thay thế (Form Chỉnh sửa)
    var fileUploadEdit = document.getElementById("fileUploadInputEdit");
    if (fileUploadEdit) {
        fileUploadEdit.addEventListener("change", function (e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    document.getElementById("imagePreviewEdit").src = event.target.result;
                    document.getElementById("previewWrapperEdit").style.display = "block";
                };
                reader.readAsDataURL(file);
            } else {
                document.getElementById("previewWrapperEdit").style.display = "none";
            }
        });
    }

    // 4. Hiển thị Modal xác nhận xóa sản phẩm
    $(".btn-delete").click(function () {
        var id = $(this).data("id");
        var name = $(this).data("name");
        $("#deleteId").val(id);
        $("#deleteCode").text(id);
        $("#deleteName").text(name);
        var modalEl = document.getElementById("deleteModal");
        if (modalEl) {
            var modal = new bootstrap.Modal(modalEl);
            modal.show();
        }
    });
});
