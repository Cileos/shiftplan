#= require gimmicks
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

    # OPTIMIZE over long time, transfer this to ember?
    routie 'scheduling /scheduling/:id', (id)->
      $scheduling = cursor.findByCid(id)
      if $scheduling.length == 1
        cursor.focus($scheduling)
        cursor.activate() unless cursor.isReadonly()

    refresh_behaviour_of_cell = ->
      $cell = $(this)
      $cell.find('.scheduling:not(.shift)').each ->
        $scheduling = $(this)
        Clockwork.appendGimmicks($scheduling)

    $calendar.find('td').each refresh_behaviour_of_cell
    $calendar.on 'update', 'td', refresh_behaviour_of_cell
    $calendar.on 'update', -> $calendar.find('td').each refresh_behaviour_of_cell

  $('nav a#new_scheduling_button').live 'ajax:success', ->
    Clockwork.SchedulingEditor.create element: $('#modalbox form:first')
    true


  parseIso8601 = (str) ->
    return null unless str?
    $.datepick.parseDate('yyyy-mm-dd', str)


  $('a#goto').show().each ->
    $cal = $('#calendar')
    $link = $(this)
    # picker must not be :hidden for offset calculation
    $picker = $('<input type="text" />').addClass('invisibleNotHidden').insertAfter($link)
    $link.click (e) ->
      e.stopPropagation()
      e.preventDefault()
      $picker.datepick 'show', e
      false
    $picker.datepick
      showOnFocus: false
      defaultDate: parseIso8601( $cal.data('monday') )
      minDate: parseIso8601( $cal.data('starts_at') )
      maxDate: parseIso8601( $cal.data('ends_at') )
      showOtherMonths: true
      onSelect: (dates) ->
        date = dates[0]
        year = date.getFullYear()
        week = $.datepick.iso8601Week(date)
        url = $link.attr('href').replace(/\d+\/\d+$/, "#{year}/#{week}")
        window.location.assign url
