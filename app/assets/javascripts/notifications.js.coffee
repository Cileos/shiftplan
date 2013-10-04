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

  $openDropdown = -> $('li.dropdown.open')

  $('a#notifications-count').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    if $hub().hasClass('open')
      closeHub()
    else
      openHub()
      $('body').trigger 'tack'
    false

  $(document).click (e) ->
    if $openDropdown().length > 0
      e.preventDefault()
      e.stopPropagation()
      closeHub()

  $openDropdown().click (e) ->
    e.stopPropagation()

  handleKeydown = (event) ->
    if event.which == 27 # ESC
      if $hub().hasClass('open')
        event.stopPropagation()
        event.preventDefault()
        closeHub()
        false
      else
        true
