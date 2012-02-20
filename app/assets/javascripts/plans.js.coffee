jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    cursor = new CalendarCursor $calendar

    $new_link = $('a.new_scheduling')
    $modal    = $("#{$new_link.data('href')}")

    $form     = $modal.find('form').clone()
    $body     = $modal.find('.modal-body')

    $calendar.bind 'calendar.cell_activate', (event, cell) =>
      editor = new CalendarEditor cell: $(cell), form: $form.clone()
      $body.html(editor)
      $new_link.click()
