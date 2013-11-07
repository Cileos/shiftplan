# Please include all needed application specific JS files manually
#= require ./clockwork
#= require defaults
#= require employees
#= require plans
#= require comments
#= require teams
#= require 'calendar/cursor'
#= require 'calendar/vertical_positioning'
#= require_tree './editors'
#= require mailcheck
#= require collapsible
#= require sidebars
#= require instructions
# always last!
#= require lib/loaded_page
#= require jquery_nested_form
#= require notifications

#= require_self

jQuery ->
  if parseInt($('#browser-width-detection').css('max-width')) <= 525 || (parseInt($('#browser-width-detection').css('max-width')) <= 625 && $('#browser-width-detection').css('content') == 'landscape')
    $("#calendar").stickyTableHeaders fixedOffset: 0
  else
    $("#calendar").stickyTableHeaders fixedOffset: 50
  $("textarea").autosize()
  $("body").on "dialogopen", ->
    elmTextarea = $(".ui-widget textarea")
    windowH = $(window).height() / 2 - 100
    elmTextarea.css "max-height", windowH + "px"
    elmTextarea.autosize()

  $('#keyboard-shortcuts [data-toggle="collapsible-heading"]').click()  unless $.cookie("clockwork_keyboard-shortcuts")
