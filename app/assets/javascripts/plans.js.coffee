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

    # activate first calendar data celli
    $('table#calendar tbody tr:nth-child(1) td:nth-child(2)').addClass('active')

    $('body').bind 'keydown', (event) ->
      $active_cell = $('table#calendar tbody td.active')
      $target_cell = switch event.keyCode
        when 37 # arrow left
          $active_cell.closest('tr').children('td').eq($active_cell.index()-1)
        when 38 # arrow up
          $active_cell.closest('tr').prev().children('td').eq($active_cell.index())
        when 39 # arrow right
          $active_cell.closest('tr').children('td').eq($active_cell.index()+1)
        when 40 # arrow down
          $active_cell.closest('tr').next().children('td').eq($active_cell.index())

      if $target_cell.hasClass('schedulings')
        $active_cell.removeClass('active')
        $target_cell.addClass('active')
