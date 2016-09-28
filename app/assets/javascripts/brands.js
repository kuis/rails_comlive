var ready,setLogo;

setLogo = function(url,input){
    var img = $('<img>').attr('src', url).addClass("img-responsive");
    var preview = "<div style='height: 100px; width: 100px; margin-bottom: 15px;'></div>";
    $("#"+ input).val(url);
    $("#"+ input).before($(preview).html(img));
}

ready = function(){
    $("[data-toggle='tooltip'], [rel='tooltip']").tooltip();
    
    
}
$(document).ready(ready);
