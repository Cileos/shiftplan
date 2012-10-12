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

//= require ./shiftplan

// always last!
//= require lib/loaded_page

//= require_self
$(function(){
    $("#calendar").stickyTableHeaders({fixedOffset: 50});
});
