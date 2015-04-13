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
            empty: ['<div class="empty-message">','User not found','</div>'].join('\n'),
            suggestion: function (data) {
                  return '<p><img width=50 src='+data.profile_image_url +'>' + data.name + ' - ' + data.screen_name + '</p>';
            }
        }
    });

    $('#typeahead').bind('typeahead:selected', function (event, datum, name) {
        $.ajax({
            type: "POST",
            url: '/add_request',
            data: datum
        });
    });

    $('.remove-user').on('click', function() {
        var user_id = $(this).attr('id');
        $.ajax({
            type: "DELETE",
            dataType: 'JSON',
            url: "/request/" + $(this).attr('id'),
            success: function(){
                $("#user_"+user_id).remove();
            },
            error: function(data){
                console.log(data.responseText);
            }
        });
    });
});
