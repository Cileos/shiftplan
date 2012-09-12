jQuery(document).ready ->

  $.fn.refreshHtml = (content) ->
    $(this).html(content).trigger('update')


  $('table#calendar').each ->
    $calendar = $(this)

    # HACK the server side of the application has to know which mode the current
    # plan is in to update the cell accordingly. Yes, this validates the same
    # origin policy.
    $calendar.ajaxSend (e, jqxhr, settings) ->
      jqxhr.setRequestHeader('X-Shiftplan-Mode', $calendar.data('mode'))

    $hidden_mode = $("<input type='hidden' name='_shiftplan_mode' value='#{$calendar.data('mode')}' />").addClass('_shiftplan_mode')

    $('body').bind 'dialogopen', (event, ui) ->
      $(event.target).find('form:not([data-remote]):not(:has(input._shiftplan_mode))').append($hidden_mode)

    cursor = new CalendarCursor $calendar

    refresh_behaviour_of_cell = ->
      $cell = $(this)
      $cell.find('li').each ->
        $scheduling = $(this)
        $scheduling.find('a.comments:has(~ul.comments)').each ->
          $link = $(this)
          $link.popover
            content: $link.find('~ul.comments').html()
            placement: 'bottom'

    $calendar.find('td').each refresh_behaviour_of_cell
    $calendar.on 'update', 'td', refresh_behaviour_of_cell
