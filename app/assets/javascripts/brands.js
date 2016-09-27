var ready,setLogo;

setLogo = function(url,input){
    $("#"+ input).val(url);
}

ready = function(){
    $("[data-toggle='tooltip'], [rel='tooltip']").tooltip();
    
    
}
$(document).ready(ready);
