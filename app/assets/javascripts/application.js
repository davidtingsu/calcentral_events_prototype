// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= bootstrap.min
//= require tablesorter.min
//= require_tree . 
(function(){
    //http://stackoverflow.com/a/18141003/1123985
    $navbar_form = $('[role=search]');
    $select_placeholder = $('.js-searchtype');
    $select = $select_placeholder.siblings('select');
    $select_placeholder.click(function(e){
        var doClick = function() {
           'use strict';
           var event = document.createEvent('MouseEvents');
           event.initMouseEvent('mousedown', true, true, window);
           return event;
        }
        $select.focus().get(0).dispatchEvent(doClick());
    })
    $select.on('change', function(e){
        $select_placeholder.find('span').text($(this).find(":selected").text());
        text = $(this).find(":selected").val();
        if(text === 'event'){
            $navbar_form.attr({ action: '/events/search' });
        } else if( text === 'club'){
            $navbar_form.attr({ action: '/clubs/search' });
        }
    });
})()
