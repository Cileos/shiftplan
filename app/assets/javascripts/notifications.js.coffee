jQuery(document).ready ->
  $('body').on 'tick', ->
    # dont use the global spinner (global: false)
    $.ajax('/count_notifications', dataType: "script", global: false)

  setInterval ->
    $('body').trigger 'tick'
  , 60 * 1000

  register_mark_as_read_event_listeners = ->
    $('a.mark_as_read, #mark_all_as_read a').click (e) ->
      update_hub_on_mark_as_read_link_clicked(e)
    $('a.notifiable-link').click (e) ->
      mark_as_read_on_notifiable_link_clicked(e)

  update_hub_on_mark_as_read_link_clicked = (e) ->
    e.preventDefault()
    e.stopPropagation()
    $link = $(e.target)
    url = $link.attr('href')
    http_method = $link.data('method')
    send_update_notification_hub_request(url, http_method)

  mark_as_read_on_notifiable_link_clicked = (e) ->
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

  $hub = -> $('li#notification-hub')

  $notifications_list = ->$('li#notification-hub .notifications')

  clearAndSpin = (clear=false) ->
    if clear
      $notifications_list().empty()
    $notifications_list().append($notif_spin = $('<div id="notifications-spinner"></div>'))
    $notif_spin.spin()

  $('a#notifications-count').on 'click', (e) ->
    send_update_notification_hub_request('/notifications', 'get')
