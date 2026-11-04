// ============================================================================
// product-filter.js - Xử lý Lọc đa tiêu chí, Tìm kiếm, Sắp xếp & Phân trang AJAX
// ============================================================================

$(document).ready(function () {
    var currentPage = 1;

    // Hàm gọi AJAX tải lại danh sách sản phẩm (trả về PartialView _ProductListPartial)
    function loadProducts(page) {
        if (page) currentPage = page;

        var keyword = $("#keywordInput").val();
        var maChatLieu = $("#selectChatLieu").val();
        var maMau = $("#selectMauSac").val();
        var maKichThuoc = $("#selectKichThuoc").val();
        var maNuocSX = $("#selectNuocSX").val();
        var sapXep = $("#selectSort").val();

        var giaTu = "";
        var giaDen = "";
        var priceRange = $('input[name="priceRange"]:checked').val();
        if (priceRange) {
            var parts = priceRange.split("-");
            giaTu = parts[0];
            giaDen = parts[1];
        }

        $("#loadingSpinner").removeClass("d-none");
        $("#productContainer").addClass("opacity-50");

        $.ajax({
            url: "/Product/FilterProducts",
            type: "GET",
            data: {
                keyword: keyword,
                maChatLieu: maChatLieu,
                maMau: maMau,
                maKichThuoc: maKichThuoc,
                maNuocSX: maNuocSX,
                giaTu: giaTu,
                giaDen: giaDen,
                sapXep: sapXep,
                page: currentPage
            },
            success: function (html) {
                $("#productContainer").html(html);
                $("#loadingSpinner").addClass("d-none");
                $("#productContainer").removeClass("opacity-50");

                // Cuộn mượt lên đầu danh sách sản phẩm
                $("html, body").animate({
                    scrollTop: $("#productContainer").offset().top - 100
                }, 200);
            },
            error: function (xhr) {
                $("#loadingSpinner").addClass("d-none");
                $("#productContainer").removeClass("opacity-50");
                alert("Lỗi tải dữ liệu: " + xhr.statusText);
            }
        });
    }

    // Bắt sự kiện thay đổi các bộ lọc dropdown và radio
    $(".filter-input, .filter-radio-price, #selectSort").change(function () {
        loadProducts(1);
    });

    // Bắt sự kiện bấm nút tìm kiếm từ khóa
    $("#btnSearchKeyword").click(function () {
        loadProducts(1);
    });

    // Tìm kiếm khi gõ phím Enter
    $("#keywordInput").keypress(function (e) {
        if (e.which === 13) {
            e.preventDefault();
            loadProducts(1);
        }
    });

    // Bắt sự kiện click vào nút phân trang AJAX (Ủy thác sự kiện - Event Delegation)
    $("body").on("click", ".ajax-page-link", function (e) {
        e.preventDefault();
        var page = $(this).data("page");
        if (page) {
            loadProducts(page);
        }
    });

    // Nút xóa tất cả bộ lọc
    $("body").on("click", "#btnResetFilter, #btnResetAll", function () {
        $("#keywordInput").val("");
        $("#selectChatLieu").val("");
        $("#selectMauSac").val("");
        $("#selectKichThuoc").val("");
        $("#selectNuocSX").val("");
        $("#selectSort").val("");
        $("#priceAll").prop("checked", true);
        loadProducts(1);
    });
});
