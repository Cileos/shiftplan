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
#= require tutorial-toggle
# always last!
#= require lib/loaded_page
#= require jquery_nested_form
#= require notifications
#= require chosen

#= require_self

jQuery ->
  $("textarea").autosize()
  $("body").on "dialogopen", ->
    elmTextarea = $(".ui-widget textarea")
    windowH = $(window).height() / 2 - 100
    elmTextarea.css "max-height", windowH + "px"
    elmTextarea.autosize()

  $('#keyboard-shortcuts [data-toggle="collapsible-heading"]').click()  unless $.cookie("clockwork_keyboard-shortcuts")


  $hint = $('<div>').addClass('tutorial-hint')
  # from tutorial-toggle
  $('a#open-tutorial').tutorialToggle
    targetId: 'tutorial'
    appendTo: 'section[role=content]'
    hint: (selector)->
      $('.tutorial-hint').remove()

      $(selector).each ->
        $hint.
          clone().
          appendTo('body').
          position
            my: 'left center'
            at: 'right center'
            of: this
            collision: 'fit'
