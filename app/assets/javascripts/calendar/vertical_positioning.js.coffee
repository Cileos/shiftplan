jQuery(document).ready ->
  return if $('#calendar.hours-in-week').length == 0

  layout_stacks = ->
    $(this).find('.scheduling').each ->
      $scheduling = $(this)

      stack = $scheduling.data('stack')
      total = $scheduling.data('total')
      last = $scheduling.data('remaining') is 0

      $scheduling.addClass "stack-#{stack}-of-#{total}"
      $scheduling.addClass "stack-last-of-#{total}" if last

  $('#calendar.hours-in-week').each ->
    $calendar = $(this)
    $calendar.on 'update', 'td', layout_stacks
    $calendar.find('td').each layout_stacks

  if jQuery.browser.mozilla
    $('#calendar.hours-in-week td').wrapInner('<div style="padding: 2px; height: 100%; width: 100%; position: relative" />')
                                   .css('padding', '0')
