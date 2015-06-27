$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block

    $('.best_in_place').best_in_place();

    $('.checker').on('change', function () {
        $('.checker.hide:first').removeClass('hide').addClass("fadeIn");
    });

});