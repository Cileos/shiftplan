jQuery(document).ready ->

  $('table#calendar').each ->
    $calendar = $(this)
    $calendar.find('abbr').tooltip()
    cursor = new CalendarCursor $calendar

    refresh_behaviour_of_cell = ->
      $cell = $(this)
      $cell.find('abbr').tooltip()
      $cell.find('li').each ->
        $scheduling = $(this)
        $scheduling.find('a.comments:has(~ul.comments)').each ->
          $link = $(this)
          $link.popover
            content: $link.find('~ul.comments').html()
            placement: 'bottom'

    $calendar.find('td').each refresh_behaviour_of_cell
    $calendar.on 'update', 'td', refresh_behaviour_of_cell
