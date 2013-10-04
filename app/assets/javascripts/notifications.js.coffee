jQuery(document).ready ->
  $('body').on 'tick', ->
    $.getScript('/count_notifications')

  $('body').on 'tack', ->
    $.getScript('/notifications')

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  $('a#notifications-count').on 'click', (event) ->
    event.preventDefault()
    event.stopPropagation()
    $hub = $('li#notification-hub')
    if $hub.hasClass('open')
      $hub.removeClass('open')
    else
      $('li#notification-hub').addClass('open')
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
