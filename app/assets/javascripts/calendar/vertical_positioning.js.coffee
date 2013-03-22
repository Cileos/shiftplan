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

    # cache. Don't you dare to zoom!
    hourHeight = $calendar.find('tbody').innerHeight() / 23

    setupResizable = ($div) ->
      $div.resizable
        handles: 'n,s'
        ghost: true
        helper: 'resizing'
        grid: [0, hourHeight]
        resize: (event, ui) -> console.debug "resized!"

    $calendar.on 'mousemove', 'td .scheduling:not(.ui-resizable)', (event) ->
      setupResizable $(this)

  if jQuery.browser.mozilla
    $('#calendar.hours-in-week td').wrapInner('<div style="padding: 2px; height: 100%; width: 100%; position: relative" />')
                                   .css('padding', '0')
