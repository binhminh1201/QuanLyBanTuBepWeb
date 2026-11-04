// ============================================================================
// cart.js - Cập nhật số lượng & Xóa sản phẩm trong Giỏ hàng bằng AJAX
// Áp dụng cho trang: Views/Cart/Index.cshtml
// ============================================================================

$(document).ready(function () {
    // Thay đổi số lượng sản phẩm bằng AJAX
    $(".input-cart-qty").change(function () {
        var id = $(this).data("id");
        var qty = parseInt($(this).val()) || 1;
        if (qty <= 0) qty = 1;

        $.ajax({
            url: "/Cart/UpdateQuantity",
            type: "POST",
            data: { id: id, quantity: qty },
            success: function (res) {
                if (res.success) {
                    $("#item-total-" + id).text(res.itemTotal);
                    $("#cartSubtotal").text(res.cartTotal);
                    $("#cartGrandTotal").text(res.cartTotal);
                    $("#cartCountBadge").text(res.totalCount);
                }
            }
        });
    });

    // Xóa sản phẩm khỏi giỏ hàng bằng AJAX
    $(".btn-remove-item").click(function () {
        var id = $(this).data("id");
        if (confirm("Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?")) {
            $.ajax({
                url: "/Cart/RemoveItem",
                type: "POST",
                data: { id: id },
                success: function (res) {
                    if (res.success) {
                        $("#row-" + id).fadeOut(300, function () {
                            $(this).remove();
                            if ($("tbody tr").length === 0) {
                                location.reload();
                            }
                        });
                        $("#cartSubtotal").text(res.cartTotal);
                        $("#cartGrandTotal").text(res.cartTotal);
                        $("#cartCountBadge").text(res.totalCount);
                    }
                }
            });
        }
    });
});
