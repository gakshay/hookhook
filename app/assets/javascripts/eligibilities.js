$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block

    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.ajaxOptions = {type: "PUT"};
    $.fn.editable.defaults.showbuttons = false;
    $.fn.editable.defaults.emptytext = '- - - - - - - - - - ';

    $('.fill-in-the-blank').editable();

//    $('.best_in_place').best_in_place();
    $('.checker').on('change', function () {
        $('.checker.hide:first').removeClass('hide').addClass("fadeIn");
    });
});
