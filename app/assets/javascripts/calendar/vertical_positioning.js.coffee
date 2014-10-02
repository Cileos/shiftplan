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

    $previewTemplate = $('<div></div>').addClass('resize-preview')
    # cache. Don't you dare to zoom!
    hourHeight = $calendar.find('tbody').innerHeight() / 24 # hours
    min = hourHeight / 4
    inHours = (pix)->
      quarters = pix / (hourHeight / 4)
      Math.round(quarters) / 4
    setupResizable = ($div) ->
      $preview = $previewTemplate.clone().appendTo($div)
      $div.resizable
        handles: 'n,s'
        ghost: true
        helper: 'resizing'
        minHeight: min
        grid: [0, min]
        resize: (event, ui)=>
          hours = inHours(ui.size.height)
          rounded = hours * hourHeight
          $preview.text(hours)
          ui.helper.height rounded
          true
        stop: (event, ui)=>
          height = ui.size.height
          hours = inHours(ui.size.height)
          console.debug "resized! to #{hours}h (#{height}pixels)"


    $calendar.on 'mousemove', 'td .scheduling:not(.ui-resizable)', (event) ->
      setupResizable $(this)

  if jQuery.browser.mozilla
    $('#calendar.hours-in-week td').wrapInner('<div style="padding: 2px; height: 100%; width: 100%; position: relative" />')
                                   .css('padding', '0')
