var ready;

ready = function(){
    $("button#claim-brand").click(function(e){
        e.preventDefault();

        var form = $("form#new_ownership");
        form.submit();
    });

    $("#assign-standard").click(function(e){
        var form = $("form#new_standardization");
        form.submit();
    });
}

$(document).on('turbolinks:load', ready);