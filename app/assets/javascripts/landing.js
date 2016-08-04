// This is a manifest file that'll be compiled into landing.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap

function menuShowHide(){
    if( $(window).scrollTop() > 50 ){

        $('.navbar-brand').removeClass('visible-xs');
        $('.navbar-fixed-top').addClass('navbar-bg')
    }

    else{
        $('.navbar-brand').addClass('visible-xs');
        $('.navbar-fixed-top').removeClass('navbar-bg');
    }
}

$(window).scroll(function(){
    menuShowHide();
});

//scrolling for top navigation
var ready;

ready = function(){
    menuShowHide();

    $('a[href*="#"]:not([href="#"])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html, body').animate({
                    scrollTop: target.offset().top - $('.navbar').outerHeight()
                }, 1000);
                return false;
            }
        }
    });
}

$(document).ready(ready);
$(document).on('turbolinks:load', ready);