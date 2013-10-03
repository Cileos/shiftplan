jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/count_notifications')

  $('body').on 'tack', ->
    $.getScript('/notifications')

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  addMouseEnterListener = ->
    $('a#notifications-count').mouseenter  ->
      $('body').trigger 'tack'

  $('body').on 'update', => addMouseEnterListener()

  addMouseEnterListener()
