jQuery(document).ready ->
  $('body').on 'tick', ->
    # dont use the global spinner (global: false)
    $.ajax('/count_notifications', dataType: "script", global: false)

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  $('body').on 'tack', ->
    send_update_notification_hub_request('/notifications', 'get')

  register_mark_as_read_event_listeners = ->
    $('a.mark_as_read,li#mark_all_as_read a').click (e) ->
      handle_mark_as_read_link_clicked(e)
    $('a.notifiable-link').click (e) ->
      handle_notifiable_link_clicked(e)

  handle_mark_as_read_link_clicked = (e) ->
    e.preventDefault()
    e.stopPropagation()
    $link = $(e.target)
    url = $link.attr('href')
    http_method = $link.data('method')
    send_update_notification_hub_request(url, http_method)

  handle_notifiable_link_clicked = (e) ->
    $link = $(e.target)
    $mark_as_read_link = $link.closest('li').find('a.mark_as_read')
    url = $mark_as_read_link.attr('href')
    http_method = $mark_as_read_link.data('method')
    send_update_notification_hub_request(url, http_method)

  send_update_notification_hub_request = (url, http_method) ->
    # dont use the global spinner (global: false)
    # spinner will be automatically removed through ul replacement
    $.ajax(url,
      type: http_method,
      dataType: "script",
      global: false,
      beforeSend: -> clearAndSpin(),
      complete: -> register_mark_as_read_event_listeners())

  enable_close_on_esc = ->
    $('body').bind 'keydown', handle_keydown

  disable_close_on_esc = ->
    $('body').unbind 'keydown', handle_keydown

  $hub = -> $('li#notification-hub')

  $notifications_list = ->$('li#notification-hub .notifications')

  close_hub = ->
    $hub().removeClass('open')
    disable_close_on_esc()

  open_hub = ->
    $hub().addClass('open')
    enable_close_on_esc()

  $opened_hub = -> $('li#notification-hub.open')

  hub_is_open = -> $opened_hub().length > 0

  clearAndSpin = ->
    $notifications_list()
      .append($notif_spin = $('<li id="notifications-spinner"></li>'))
    $notif_spin.spin()

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
      if $(e.target).parents('#notification-hub').length == 0
        e.preventDefault()
        e.stopPropagation()
        close_hub()

  handle_keydown = (e) ->
    if e.which == 27 # ESC
      if $hub().hasClass('open')
        e.stopPropagation()
        e.preventDefault()
        close_hub()
        false
      else
        true
