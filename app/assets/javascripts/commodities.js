var ready, table;
var renderOptions = function(options, select){
    var opts = [];
    opts.push($('<option>').val("").text('Select Chapter'));
    options.forEach(function(option){
        var opt = $('<option>').val(option.id).text(option.description);
        opts.push(opt);
    });
    select.html(opts);
}

ready = function(){
    $("input#commodity_generic").change(function(){
        var checked = $(this).is(":checked");
        var select = $("select#commodity_brand_id");

        if(checked){
            select.prop("selectedIndex", 0);
            select.hide();
        } else {
            select.show();
        }
    });

    $("button#set-status").click(function(e){
        e.preventDefault();

        var form = $("form#commodity-state");
        form.submit();
    });

    $("button#add-packaging").click(function(e){
        e.preventDefault();

        var form = $(this).parents('.modal-content').find("form");
        form.submit();
    });

    $("button#assign-hscode").click(function(e){
        e.preventDefault();

        var form = $(this).parents('.modal-content').find("form");
        form.submit();
    });

    $("select#commodity_hscode_section_id").change(function(){
        var selected = $(this).find(":selected");
        var value    = selected.val();
        var url      = $(this).data("href");

        var child_select = $("select#commodity_hscode_chapter_id");
        child_select.html('<option>Loading....</option>');
        $("select#commodity_hscode_heading_id").html('<option value="">Select Heading</option>');
        $("select#commodity_hscode_subheading_id").html('<option value="">Select Sub Heading</option>');

        $.ajax({
            type: "GET",
            url: url,
            data: { hscode_section_id: value },
            success: function(data){
                renderOptions(data, child_select);
            }
        });
    });

    $("select#commodity_hscode_chapter_id").change(function(){
        var selected = $(this).find(":selected");
        var value    = selected.val();
        var url      = $(this).data("href");

        var child_select = $("select#commodity_hscode_heading_id");
        child_select.html('<option>Loading....</option>');

        $.ajax({
            type: "GET",
            url: url,
            data: { hscode_chapter_id: value },
            success: function(data){
                renderOptions(data, child_select);
            }
        });
    });

    $("select#commodity_hscode_heading_id").change(function(){
        var selected = $(this).find(":selected");
        var value    = selected.val();
        var url      = $(this).data("href");

        var child_select = $("select#commodity_hscode_subheading_id");
        child_select.html('<option>Loading....</option>');

        $.ajax({
            type: "GET",
            url: url,
            data: { hscode_heading_id: value },
            success: function(data){
                renderOptions(data, child_select);
            }
        });
    });

    table = $('table#unspsc_segments').DataTable({
        pagingType: "full_numbers",
        bProcessing: true,
        bServerSide: true,
        sAjaxSource: $('table#unspsc_segments').data('source'),
        "order": []
    });
}

$(document).on("click", "a.unspsc-drilldown", function(e){
    e.preventDefault();

    var url = $(this).data("href");
    var type = $(this).data("type");
    table.ajax.url(url).load();

    $('#unspsc_segments caption').text("UNSPSC " + type);
});

$(document).on("click","a.assign-unspsc", function(e){
    e.preventDefault();

    var url = $("#unspsc_segments").data("submit-url");
    var unspsc_commodity_id = $(this).data("id");

    $.ajax({
        type: "PATCH",
        url: url,
        data: { commodity: { unspsc_commodity_id: unspsc_commodity_id } }
    });
})

$(document).on('turbolinks:load', ready);