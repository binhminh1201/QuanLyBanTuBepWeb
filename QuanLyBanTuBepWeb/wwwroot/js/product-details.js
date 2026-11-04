// ============================================================================
// product-details.js - Xử lý chuyển góc ảnh & Thêm giỏ hàng theo số lượng bằng AJAX
// Áp dụng cho trang: Views/Product/Details.cshtml
// ============================================================================

$(document).ready(function () {
    // Chuyển đổi góc chụp ảnh khi click thumbnail
    $(".thumb-item").on("click", function () {
        $(".thumb-item").removeClass("active-thumb");
        $(this).addClass("active-thumb");
        var newSrc = $(this).data("src");
        var label = $(this).data("label");

        $("#mainProductImg").css("opacity", "0.4");
        setTimeout(function () {
            $("#mainProductImg").attr("src", newSrc).css("opacity", "1");
        }, 150);

        $("#imgAngleBadge").html('<i class="bi bi-camera me-1"></i> ' + label);
    });

    var maxQty = parseInt($("#inputQuantity").attr("max")) || 0;

    $("#btnMinus").click(function () {
        var val = parseInt($("#inputQuantity").val()) || 1;
        if (val > 1) $("#inputQuantity").val(val - 1);
    });

    $("#btnPlus").click(function () {
        var val = parseInt($("#inputQuantity").val()) || 1;
        if (val < maxQty) $("#inputQuantity").val(val + 1);
    });

    $("#btnAddToCart").click(function () {
        var qty = parseInt($("#inputQuantity").val()) || 1;
        var id = $(this).data("id");

        $.ajax({
            url: "/Cart/AddToCart",
            type: "POST",
            data: { id: id, quantity: qty },
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
