$(document).ready(function(){
    var commodities_autocomplete_url = $("#global-search-form").data("comm-url");

    commodityEngine = new Bloodhound({
        identify: function(o) { return o.id; },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
        dupDetector: function(a, b) { return a.id === b.id; },
        remote: {
            url:  commodities_autocomplete_url + '?query=%QUERY',
            wildcard: '%QUERY'
        }
    });

    $("#global-search").typeahead({
        minLength: 2,
        highlight: true,
        hint: true
    }, {
        source: commodityEngine,
        displayKey: 'name',
        templates:{
            suggestion:function(data) {
                return "<a href=" + data.href + ">"+ data.name +"</a>";
            }
        }
    });
})
