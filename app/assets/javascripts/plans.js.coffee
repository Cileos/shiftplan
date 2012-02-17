jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    $body     = $calendar.find('tbody:first')
    $new_link = $('a.new_scheduling')
    $modal    = $("#{$new_link.data('href')}")

    focussed_cell = ->
      $body.find('td.focus')

    $calendar.on 'click', 'tbody td', ->
      $calendar.trigger 'calendar.cell_focus', this
      $calendar.trigger 'calendar.cell_activate', this

    $form     = $modal.find('form').clone()
    $body     = $modal.find('.modal-body')

    $calendar.bind 'calendar.cell_activate', (event, cell) =>
      editor = new CalendarEditor cell: $(cell), form: $form.clone()
      $body.html(editor)
      $new_link.click()

    $calendar.bind 'calendar.cell_focus', (event, cell) =>
      $cell = $(cell)
      focussed_cell().removeClass('focus')
      $cell.addClass('focus')

    # focus first calendar data cell
    $calendar.trigger 'calendar.cell_focus', $body.find('tr:nth-child(1) td:nth-child(2)')

    # which tds do we want to navigate
    tds = 'td:not(.hours)'

    columns_count = focussed_cell().closest('tr').children(tds).size()
    rows_count = focussed_cell().closest('tbody').children('tr').size()

    $('body').bind 'keydown', (event) ->
      $focus  = focussed_cell()
      column  = $focus.closest('tr').children(tds).index($focus)
      row     = $focus.closest('tbody').children('tr').index($focus.closest('tr'))
      $target = switch event.keyCode
        when 37 # arrow left
          $focus.closest('tr').children(tds).eq(column-1)
        when 38 # arrow up
          if row - 1 < 0
            row = rows_count - 1
          else
            row = row - 1
          $focus.closest('tbody').children('tr').eq(row).children(tds).eq(column)
        when 39 # arrow right
          $focus.closest('tr').children(tds).eq( (column+1) % columns_count )
        when 40 # arrow down
          $focus.closest('tbody').children('tr').eq( (row+1) % rows_count ).children(tds).eq(column)

      if $target
        $calendar.trigger 'calendar.cell_focus', $target
