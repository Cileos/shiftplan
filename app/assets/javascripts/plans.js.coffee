jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    cursor = new CalendarCursor $calendar
