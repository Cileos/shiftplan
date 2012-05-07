jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    cursor = new CalendarCursor $calendar

    $calendar.bind 'calendar.cell_activate', (event, cell) =>
      editor = new CalendarEditor cell: $(cell)
