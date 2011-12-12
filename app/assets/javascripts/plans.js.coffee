jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    $new_link = $('a.new_scheduling')
    $new_form = $('form#new_scheduling')

    $calendar.on 'click', 'tbody td', ->
      $calendar.trigger 'calendar.cell_activate', this

    $calendar.bind 'calendar.cell_activate', (event, cell) =>
      $cell = $(cell)
      $new_link.click()
      $new_form.find('select#scheduling_employee_id').val($cell.data('employee_id')).change()
      $new_form.find('select#scheduling_day').val($cell.data('day')).change()
