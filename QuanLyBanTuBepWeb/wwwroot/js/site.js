// ============================================================================
// site.js - Script dùng chung toàn hệ thống Showroom Tủ Bếp KITCHENLUX
// Được nạp tự động trong _Layout.cshtml qua Tag Helper asp-append-version="true"
// ============================================================================

$(document).ready(function () {
    // Ủy thác sự kiện (Event Delegation): Thêm nhanh sản phẩm vào giỏ hàng bằng AJAX
    // Hoạt động trên cả Trang chủ, Danh sách sản phẩm và cả sau khi lọc/phân trang AJAX
    $("body").on("click", ".btn-add-cart", function (e) {
        e.preventDefault();
        var productId = $(this).data("id");

        $.ajax({
            url: "/Cart/AddToCart",
            type: "POST",
            data: { id: productId, quantity: 1 },
            success: function (res) {
                if (res.success) {
                    $("#cartCountBadge").text(res.totalCount);
                    $("#toastMessage").html('<i class="bi bi-check-circle-fill me-2"></i>' + res.message);
                    var toastEl = document.getElementById("cartToast");
                    if (toastEl) {
                        var toast = new bootstrap.Toast(toastEl);
                        toast.show();
                    }
                } else {
                    alert(res.message);
                }
            },
            error: function () {
                alert("Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!");
            }
        });
    });
});
