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
#= require lib/tooltips
#= require instructions
# always last!
#= require lib/loaded_page
#= require jquery_nested_form

#= require_self

jQuery ->
  $("#calendar").stickyTableHeaders fixedOffset: 50
  $("textarea").autosize()
  $("body").on "dialogopen", ->
    elmTextarea = $(".ui-widget textarea")
    windowH = $(window).height() / 2 - 100
    elmTextarea.css "max-height", windowH + "px"
    elmTextarea.autosize()

  $('#keyboard-shortcuts [data-toggle="collapsible-heading"]').click()  unless $.cookie("clockwork_keyboard-shortcuts")

  $('header[role=banner] li.dropdown').doubleTapToGo()
