// constructs the suggestion engine
$(document).on('page:change', function () {
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
    });

    $('#typeahead').bind('typeahead:selected', function (event, datum, name) {
        $.ajax({
            type: "POST",
            url: '/add_request',
            data: datum,
            success: function (data) {
                $(this).value='';
            }
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
});
