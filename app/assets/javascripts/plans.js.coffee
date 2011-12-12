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

    columns_count = $('table#calendar tbody td.active').closest('tr').children('td').size()
    rows_count = $('table#calendar tbody td.active').closest('tbody').children('tr').size()

    $('body').bind 'keydown', (event) ->
      $active_cell = $('table#calendar tbody td.active')
      column_index = $active_cell.closest('tr').children('td').index($active_cell)
      row_index = $active_cell.closest('tbody').children('tr').index($active_cell.closest('tr'))
      $target_cell = switch event.keyCode
        when 37 # arrow left
          $active_cell.closest('tr').children('td').eq(column_index-1)
        when 38 # arrow up
          if row_index - 1 < 0
            row_index = rows_count - 1
          else
            row_index = row_index - 1
          $active_cell.closest('tbody').children('tr').eq(row_index).children('td').eq(column_index)
        when 39 # arrow right
          $active_cell.closest('tr').children('td').eq((column_index+1)%columns_count)
        when 40 # arrow down
          $active_cell.closest('tbody').children('tr').eq((row_index+1)%rows_count).children('td').eq(column_index)

      if $target_cell
        $active_cell.removeClass('active')
        $target_cell.addClass('active')
