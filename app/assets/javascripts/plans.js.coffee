jQuery(document).ready ->

  $.fn.refreshHtml = (content) ->
    $(this).html(content).trigger('update')

  # HACK the server side of the application has to know which mode the current
  # plan is in to update the cell accordingly. Yes, this validates the same
  # origin policy.
  $('table#calendar').ajaxSend (e, jqxhr, settings) ->
    jqxhr.setRequestHeader('X-Shiftplan-Mode', $(this).data('mode'))

  $('table#calendar').each ->
    $calendar = $(this)
    cursor = new CalendarCursor $calendar

    refresh_behaviour_of_header = ->
      $cell = $(this)
      $cell.find('abbr').tooltip()

    $calendar.on 'update', 'th', refresh_behaviour_of_header
    $calendar.find('th').each refresh_behaviour_of_header

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
