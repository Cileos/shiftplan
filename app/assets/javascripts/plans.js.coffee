# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    $new_link = $('.actions a.new_scheduling')
    $('tbody td', $calendar[0]).live 'click', ->
      $cell = $(this)
      $.get $new_link.attr('href'),
        scheduling:
          employee_id: $cell.data('employee_id')
          day: $cell.data('day')
        , null, 'script'
