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

    $('#typeahead').typeahead(null, {
        displayKey: 'name',
        source: bloodhound.ttAdapter(),
        templates: {
            empty: ['<div class="empty-message">','User not found','</div>'].join('\n'),
            suggestion: function (data) {
                return '<p><strong>' + data.name + '</strong> - ' + data.screen_name + '</p>';
            }
        }
    });

    $('#typeahead').bind('typeahead:selected', function (event, datum, name) {
        alert(datum);
        $.ajax({
            type: "POST",
            url: '/add_user',
            data: data,
            success: success,
            dataType: dataType
        });
    });
});