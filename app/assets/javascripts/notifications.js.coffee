jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/count_notifications')

  $('body').on 'tack', ->
    $.getScript('/notifications')

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  enable_close_on_esc = ->
    $('body').bind 'keydown', handle_keydown

  disable_close_on_esc = ->
    $('body').unbind 'keydown', handle_keydown

  $hub = -> $('li#notification-hub')

  close_hub = ->
    $hub().removeClass('open')
    disable_close_on_esc()

  open_hub = ->
    $hub().addClass('open')
    enable_close_on_esc()

  $opened_hub = -> $('li#notification-hub.open')

  hub_is_open = -> $opened_hub().length > 0

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

  $opened_hub().click (e) ->
    e.stopPropagation()

  handle_keydown = (e) ->
    if e.which == 27 # ESC
      if $hub().hasClass('open')
        e.stopPropagation()
        e.preventDefault()
        close_hub()
        false
      else
        true
