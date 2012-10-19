// Please include all needed application specific JS files manually
//= require defaults
//= require employees
//= require plans
//= require comments
//= require teams
//= require 'calendar/cursor'
//= require 'calendar/vertical_positioning'
//= require_tree './editors'
//= require mailcheck
//= require help
//= require legend
// always last!
//= require lib/loaded_page

$(function(){
    $("#calendar").stickyTableHeaders({fixedOffset: 50});
    $("textarea").autosize();

    $("body").on("dialogopen", function() {
      $(".ui-widget textarea").autosize();
    });
});
