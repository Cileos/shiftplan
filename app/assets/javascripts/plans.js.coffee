jQuery(document).ready ->

  $.fn.refreshHtml = (content) ->
    $(this).html(content).trigger('update')

  $.fn.scrollTo = ->
    h = $(window).height() / 3
    $('html, body').animate({
        scrollTop: $(this).offset().top - h
    },200)

  $('table#calendar').each ->
    $calendar = $(this)

    # HACK the server side of the application has to know which mode the current
    # plan is in to update the cell accordingly. Yes, this validates the same
    # origin policy.
    $calendar.ajaxSend (e, jqxhr, settings) ->
      jqxhr.setRequestHeader('X-Clockwork-Mode', $calendar.data('mode'))

    $hidden_mode = $("<input type='hidden' name='_clockwork_mode' value='#{$calendar.data('mode')}' />").addClass('_clockwork_mode')

    $('body').bind 'dialogopen', (event, ui) ->
      $(event.target).find('form:not(:has(input._clockwork_mode))').append($hidden_mode)

    cursor = new CalendarCursor $calendar

    refresh_behaviour_of_cell = ->
      $cell = $(this)
      $cell.find('li.scheduling').each ->
        $scheduling = $(this)
        $scheduling.find('a.comments:has(~ul.comments)').each ->
          $link = $(this)
          # $link.popover
          #   content: $link.find('~ul.comments').html()
          #   placement: 'bottom'

    $calendar.find('td').each refresh_behaviour_of_cell
    $calendar.on 'update', 'td', refresh_behaviour_of_cell

  $('nav a.new_scheduling').live 'ajax:success', ->
    Clockwork.SchedulingEditor.create element: $('#modalbox form:first')
    true
