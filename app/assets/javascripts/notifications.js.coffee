jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/count_notifications')

  $('body').on 'tack', ->
    $.getScript('/notifications')

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  enable_close_on_esc = ->
    $('body').bind 'keydown', handleKeydown

  disable_close_on_esc = ->
    $('body').unbind 'keydown', handleKeydown

  $hub = -> $('li#notification-hub')

  close_hub = ->
    $hub().removeClass('open')
    disable_close_on_esc()

  open_hub = ->
    $hub().addClass('open')
    enable_close_on_esc()

  $openedHub = -> $('li#notification-hub.open')

  hub_is_open = -> $openedHub().length > 0

  $('a#notifications-count').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    if $hub().hasClass('open')
      close_hub()
    else
      open_hub()
      $('body').trigger 'tack'
    false

  $(document).click (e) ->
    if hub_is_open()
      e.preventDefault()
      e.stopPropagation()
      close_hub()

  $openedHub().click (e) ->
    e.stopPropagation()

  handleKeydown = (e) ->
    if e.which == 27 # ESC
      if $hub().hasClass('open')
        e.stopPropagation()
        e.preventDefault()
        close_hub()
        false
      else
        true
