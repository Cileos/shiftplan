jQuery(document).ready ->
  return if $('#calendar.hours-in-week').length == 0

  layout_stacks = ->
    $(this).find('.scheduling').each ->
      $scheduling = $(this)

      stack = $scheduling.data('stack')
      total = $scheduling.data('total')

      entry_width = 100 / total

      $scheduling.css
        width:   2*entry_width-4 + '%'
        left:    stack * entry_width + 2 + '%'
        zIndex:  100 - total + stack

      if $scheduling.data('remaining') == 0
        $scheduling.css 'width', entry_width-4 + '%'

  $('#calendar.hours-in-week').each ->
    $calendar = $(this)
    $calendar.on 'update', 'td', layout_stacks
    $calendar.find('td').each layout_stacks

  if jQuery.browser.mozilla
    $('#calendar.hours-in-week td').wrapInner('<div style="padding: 2px; height: 100%; width: 100%; position: relative" />')
                                   .css('padding', '0')
