jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/count_notifications')

  $('body').on 'tack', ->
    $.getScript('/notifications')

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  enableCloseOnEsc = ->
    $('body').bind 'keydown', handleKeydown

  disableCloseOnEsc = ->
    $('body').unbind 'keydown', handleKeydown

  $hub = -> $('li#notification-hub')

  closeHub = ->
    $hub().removeClass('open')
    disableCloseOnEsc()

  openHub = ->
    $hub().addClass('open')
    enableCloseOnEsc()

  $openedHub = -> $('li#notification-hub.open')

  hubIsOpen = -> $openedHub().length > 0

  $('a#notifications-count').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    if $hub().hasClass('open')
      closeHub()
    else
      openHub()
      $('body').trigger 'tack'
    false

  $(document).click (e) ->
    if hubIsOpen()
      e.preventDefault()
      e.stopPropagation()
      closeHub()

  $openedHub().click (e) ->
    e.stopPropagation()

  handleKeydown = (e) ->
    if e.which == 27 # ESC
      if $hub().hasClass('open')
        e.stopPropagation()
        e.preventDefault()
        closeHub()
        false
      else
        true
