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

  $('a#notifications-count').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    $hub = $('li#notification-hub')
    if $hub.hasClass('open')
      $hub.removeClass('open')
      disableCloseOnEsc()
    else
      $('li#notification-hub').addClass('open')
      enableCloseOnEsc()
      $('body').trigger 'tack'
    false

  $(document).click (e) ->
    $dropdown = $('li.dropdown.open')
    if $dropdown.length > 0
      e.preventDefault()
      e.stopPropagation()
      $dropdown.removeClass('open')

  $('li.dropdown.open').click (e) ->
    e.stopPropagation()

  handleKeydown = (event) ->
    if event.which == 27 # ESC
      $hub = $('li#notification-hub')
      if $hub.hasClass('open')
        event.stopPropagation()
        event.preventDefault()
        $hub.removeClass('open')
        disableCloseOnEsc()
        false
      else
        true
