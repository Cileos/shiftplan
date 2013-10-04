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
  $openDropdown = -> $('li.dropdown.open')

  $('a#notifications-count').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    if $hub().hasClass('open')
      $hub().removeClass('open')
      disableCloseOnEsc()
    else
      $hub().addClass('open')
      enableCloseOnEsc()
      $('body').trigger 'tack'
    false

  $(document).click (e) ->
    if $openDropdown().length > 0
      e.preventDefault()
      e.stopPropagation()
      $openDropdown().removeClass('open')

  $openDropdown().click (e) ->
    e.stopPropagation()

  handleKeydown = (event) ->
    if event.which == 27 # ESC
      if $hub().hasClass('open')
        event.stopPropagation()
        event.preventDefault()
        $hub().removeClass('open')
        disableCloseOnEsc()
        false
      else
        true
