// Please include all needed application specific JS files manually
//= require jquery.cookie
//= require defaults
//= require employees
//= require plans
//= require comments
//= require teams
//= require 'calendar/cursor'
//= require 'calendar/vertical_positioning'
//= require_tree './editors'
//= require mailcheck
//= require contextual_help
// always last!
//= require lib/loaded_page

$(function(){
    $("#calendar").stickyTableHeaders({fixedOffset: 50});
    $("textarea").autosize();

    $("body").on("dialogopen", function() {
      var elmTextarea = $('.ui-widget textarea');
      var windowH = $(window).height() / 2 - 100;

      elmTextarea.css('max-height', windowH + 'px');
      elmTextarea.autosize();
    });
});
