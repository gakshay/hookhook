$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block

    $('.best_in_place').best_in_place();

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

});

$(document).on('page:change', function () {
    $('.profile-usermenu ul li').on('click', function(){
        $(this).siblings().removeClass('active');
        $(this).addClass('active');
    });

    if ($('#logged-in-main').length){
        $('nav').addClass('navbar-shrink');
    }

    $('#founding_member_faq').on('click', function(e){
        e.preventDefault();
        $('#founding_member_faqs').toggleClass('hide');
        $('#founding_member_form_fields').toggleClass('hide');
    });

    $('#founding_member').on('click', function(e){
        e.preventDefault();
        $('#founding_member').addClass('active');
        $('#founding_member_form').removeClass('hide');

        $('#early_bird').removeClass('active');
        $('#early_bird_form').addClass('hide');
    });

    $('#early_bird').on('click', function(e){
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
                    return '<div class="media"><div class="pull-left"><img class="img-circle" src='+ data.profile_image_url +' ></div><div class="media-body"><h4 class="media-heading">'+ data.name + ': @' + data.screen_name +'<i class="verified fa fa-check-circle fa-1x"></i></h4><p>' + data.description + '</p></div></div>';
                } else {
                    return '<div class="media"><div class="pull-left"><img class="img-circle" src='+ data.profile_image_url +' ></div><div class="media-body"><h4 class="media-heading">'+ data.name + ': @' + data.screen_name +'</h4><p>' + data.description + '</p></div></div>';
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

    $('#show-stats').on('click', function(){
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


//   $("#login_modal").modal("show"});

});
