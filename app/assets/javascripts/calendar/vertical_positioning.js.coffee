jQuery(document).ready ->
  return if $('#page #calendar.hours-in-week').length == 0

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
    $calendar.on 'update', 'td.day', layout_stacks
    $calendar.find('td.day').each layout_stacks
