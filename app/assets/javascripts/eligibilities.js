$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.ajaxOptions = {type: "PUT"};
//    $.fn.editable.defaults.anim = "1000";
    $.fn.editable.defaults.showbuttons = false;
    $.fn.editableform.buttons = '<button type="submit" class="btn btn-success editable-submit"><i class="fa fa-check"></i></button>'
    + '<button type="button" class="btn editable-cancel"><i class="fa fa-times"></i></button>';

    $.fn.editable.defaults.emptytext = '- - - - - - - - - - ';

    $('.fill-in-the-blank').editable({

        display: function(value, sourceData) {
            //display checklist as comma-separated values
            var html = [],
                checked = $.fn.editableutils.itemsByValue(value, sourceData);
            if(checked.length) {
                $.each(checked, function(i, v) { html.push($.fn.editableutils.escape(v.text)); });
                $(this).html(html.join(', '));
            } else {
                $(this).empty();
            }
        },

        success: function(response, newValue) {
//            $('.checker.hide:first .checkerOut').removeClass('checkerOut').addClass('checkerIn');
            $('.start.startNow:first').removeClass('startNow').addClass('startTyping');
        },

    });


//    $('.best_in_place').best_in_place();
//    $('.checker').on('change', function () {
//        $('.checker.hide:first').removeClass('hide').addClass("fadeIn");
//    });
});
