# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    $new_link = $('.actions a.new_scheduling')
    $new_form = $('form#new_scheduling')
    $calendar.on 'click', 'tbody td', ->
      $cell = $(this)
      $new_link.click()
      $new_form.find('select#scheduling_employee_id').val($cell.data('employee_id')).change()
      $new_form.find('select#scheduling_day').val($cell.data('day')).change()
