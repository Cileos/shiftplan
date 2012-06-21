jQuery(document).ready ->

  # HACK the server side of the application has to know which mode the current
  # plan is in to update the cell accordingly. Yes, this validates the same
  # origin policy.
  $('table#calendar').ajaxSend (e, jqxhr, settings) ->
    jqxhr.setRequestHeader('X-Shiftplan-Mode', $(this).data('mode'))
    true

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
