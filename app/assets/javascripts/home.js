$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block

    $('.best_in_place').best_in_place();
    $('[data-toggle="popover"]').popover();

    $('.user-tile').on('mouseover', function () {
        $(this).find('.toggle-display').removeClass('hide');
    }).on('mouseout', function () {
        $(this).find('.toggle-display').addClass('hide');
    });

    $('a.page-scroll').on('click', function (event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });

    $('.remove-user').on('click', function () {
        var user_id = $(this).attr('id');
        $.ajax({
            type: "DELETE",
            url: "/request/" + $(this).attr('id'),
            error: function (data) {
                console.log(data.responseText);
            }
        });
    });

    $('.pinterest_list').pinterest_grid({
        no_columns: 3,
        padding_x: 10,
        padding_y: 10,
        margin_bottom: 50,
        single_column_breakpoint: 700
    });

    $('.hero_detail .best_in_place').bind("ajax:success", function (response, data) {
        var req = JSON.parse(data);
        if(req.story != null && req.story != ''){
            $('#best_in_place_request_'+req.id+'_story').removeClass('placeholder-text');
        } else {
            $('#best_in_place_request_'+req.id+'_story').addClass('placeholder-text');
        }

        if(req.emotion != null && req.emotion != '' && req.story != null && req.story != '') {
            $('#'+req.id+'_req_publish_link').removeClass('hide');
            $('#'+req.id+'_req_publish_disabled').addClass('hide');
        } else {
            $('#'+req.id+'_req_publish_link').addClass('hide');
            $('#'+req.id+'_req_publish_disabled').removeClass('hide');
        }
    });

    $('.notification').on('mouseover', function () {
        $(this).find('.toggle-display').removeClass('hide');
    }).on('mouseout', function () {
        $(this).find('.toggle-display').addClass('hide');
    });

    $('.mark-as-read').on('mouseover', function () {
        $(this).find('i.fa.fa-circle-o').addClass('fa-dot-circle-o');
    }).on('mouseout', function () {
        $(this).find('i.fa.fa-circle-o').removeClass('fa-dot-circle-o');
    });

});

$(document).on('page:change', function () {
    $('.carousel').carousel({
        interval: 5000,
        pause: "false"
    });

    $('.profile-usermenu ul li').on('click', function () {
        $(this).siblings().removeClass('active');
        $(this).addClass('active');
    });

    if ($('#logged-in-main').length) {
        $('nav').addClass('navbar-shrink');
    }

    $('#founding_member_faq').on('click', function (e) {
        e.preventDefault();
        $('#founding_member_faqs').toggleClass('hide');
        $('#founding_member_form_fields').toggleClass('hide');
    });

    $('#founding_member').on('click', function (e) {
        e.preventDefault();
        $('#founding_member').addClass('active');
        $('#founding_member_form').removeClass('hide');

        $('#early_bird').removeClass('active');
        $('#early_bird_form').addClass('hide');
    });

    $('#early_bird').on('click', function (e) {
        e.preventDefault();
        $('#founding_member').removeClass('active');
        $('#founding_member_form').addClass('hide');

        $('#early_bird').addClass('active');
        $('#early_bird_form').removeClass('hide');
    });

    var bloodhound = new Bloodhound({
        datumTokenizer: function (d) {
            return Bloodhound.tokenizers.whitespace(d.name);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/home/%QUERY',
        limit: 50
    });

    bloodhound.initialize();

    $('#typeahead').typeahead({
        hint: true,
        highlight: true
    }, {
        displayKey: 'name',
        source: bloodhound.ttAdapter(),
        templates: {
            empty: ['<div class="empty-message">', 'User not found', '</div>'].join('\n'),
            suggestion: function (data) {
                if (data.verified) {
                    return '<div class="media"><div class="pull-left"><img class="img-circle" src=' + data.profile_image_url + ' ></div><div class="media-body"><h4 class="media-heading">' + data.name + ': @' + data.screen_name + '<i class="verified fa fa-check-circle fa-1x"></i></h4><p>' + data.description + '</p></div></div>';
                } else {
                    return '<div class="media"><div class="pull-left"><img class="img-circle" src=' + data.profile_image_url + ' ></div><div class="media-body"><h4 class="media-heading">' + data.name + ': @' + data.screen_name + '</h4><p>' + data.description + '</p></div></div>';
                }
            }
        }
    }).on('typeahead:selected', function (event, datum) {
        $.ajax({
            type: "POST",
            url: '/add_request',
            data: datum
        });
    });

    $('#show-stats').on('click', function () {
        $('#admirers_stats').toggleClass('hide');
        $('#admirers_list').toggleClass('hide');
    });

// Highlight the top nav as scrolling occurs
    $('body').scrollspy({
        target: '.navbar-fixed-top'
    });

// Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function () {
        $('.navbar-toggle:visible').click();
    });

// Closes the Responsive Menu on Click outside Menu
    $('body > *').not('nav').click(function () {
        if (!$('button.navbar-toggle').hasClass('collapsed')) {
            $('.navbar-toggle:visible').click();
        }
    });
});
