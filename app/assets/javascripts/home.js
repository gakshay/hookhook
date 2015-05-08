$(document).on('page:change', function () {
    $('.profile-usermenu ul li').on('click', function(){
        $(this).siblings().removeClass('active');
        $(this).addClass('active');
    });

    if ($('#logged-in-main').length){
        $('nav').addClass('navbar-shrink');
    }
    // initialize bloodhound engine
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

    $('.user-tile').mouseover(function () {
        $(this).find('.toggle-display').removeClass('hide');
    }).mouseout(function () {
        $(this).find('.toggle-display').addClass('hide');
    });

    $('a.page-scroll').on('click', function (event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
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

//msform stuff starts
    var current_fs, next_fs, previous_fs; //fieldsets
    var left, opacity, scale; //fieldset properties which we will animate
    var animating; //flag to prevent quick multi-click glitches

    $(".next, .pitch-btn").click(function () {
        if (animating) return false;
        animating = true;

        current_fs = $(this).parent();
        next_fs = $(this).parent().next();

        //activate next step on progressbar using the index of next_fs
        //$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

        //show the next fieldset
        next_fs.show();
        //hide the current fieldset with style
        current_fs.animate({opacity: 0}, {
            step: function (now, mx) {
                //as the opacity of current_fs reduces to 0 - stored in "now"
                //1. scale current_fs down to 80%
                scale = 1 - (1 - now) * 0.2;
                //2. bring next_fs from the right(50%)
                left = (now * 50) + "%";
                //3. increase opacity of next_fs to 1 as it moves in
                opacity = 1 - now;
                current_fs.css({'transform': 'scale(' + scale + ')'});
                next_fs.css({'left': left, 'opacity': opacity});
            },
            duration: 800,
            complete: function () {
                current_fs.hide();
                animating = false;
            },
            //this comes from the custom easing plugin
            easing: 'easeInOutBack'
        });
    });

    $(".previous").click(function () {
        if (animating) return false;
        animating = true;

        current_fs = $(this).parent();
        previous_fs = $(this).parent().prev();

        //de-activate current step on progressbar
        //$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

        //show the previous fieldset
        previous_fs.show();
        //hide the current fieldset with style
        current_fs.animate({opacity: 0}, {
            step: function (now, mx) {
                //as the opacity of current_fs reduces to 0 - stored in "now"
                //1. scale previous_fs from 80% to 100%
                scale = 0.8 + (1 - now) * 0.2;
                //2. take current_fs to the right(50%) - from 0%
                left = ((1 - now) * 50) + "%";
                //3. increase opacity of previous_fs to 1 as it moves in
                opacity = 1 - now;
                current_fs.css({'left': left});
                previous_fs.css({'transform': 'scale(' + scale + ')', 'opacity': opacity});
            },
            duration: 800,
            complete: function () {
                current_fs.hide();
                animating = false;
            },
            //this comes from the custom easing plugin
            easing: 'easeInOutBack'
        });
    });

    $('.pitch-btn').on('click', function () {
        $(this).parent().find('#request_pitch_list').val($(this).text());
        var pitch = $(this).parent().next().find('#why_reaching_out');
        pitch.text($(this).text());
        if(pitch.attr("class")){
            var pitchClassNames = pitch.attr("class").toString().split(' ');
            $.each(pitchClassNames, function (i, className) {
                pitch.removeClass(className);
            });
        }
        var classNames = $(this).attr("class").toString().split(' ');
        $.each(classNames, function (i, className) {
            pitch.addClass(className);
        });
        pitch.removeClass('pitch-btn');

    });

//msform stuff ends

    var admirer_data = [];
    $.getJSON( "/admirers", function( data ) {
        admirer_data = data.tags;

        // Build the chart
        $('#requestChartContainer').highcharts({
            credits: {
                enabled: false
            },
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'People are looking forward to catchup with you!'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            },
            series: [{
                type: 'pie',
                name: 'Requests',
                data: admirer_data
            }]
        });

    });




});
