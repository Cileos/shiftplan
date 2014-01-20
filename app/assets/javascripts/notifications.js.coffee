jQuery(document).ready ->
  # Only update notification hub when a user is signed in
  $('li#session-and-settings').each ->
    $('body').on 'tick', ->
      # dont use the global spinner (global: false)
      $.ajax('/count_notifications', dataType: "script", global: false)

    setInterval ->
      $('body').trigger 'tick'
    , 60 * 1000

    register_mark_as_read_event_listeners = ->
      $('a.mark_as_read, #mark_all_as_read a').click (e) ->
        update_hub_on_mark_as_read_link_clicked(e)

    update_hub_on_mark_as_read_link_clicked = (e) ->
      e.preventDefault()
      e.stopPropagation()
      $link = $(e.target)
      url = $link.attr('href')
      http_method = $link.data('method')
      send_update_notification_hub_request(url, http_method)

    send_update_notification_hub_request = (url, http_method) ->
      # dont use the global spinner (global: false)
      # spinner will be automatically removed through ul replacement

      fetch = $.ajax(url,
        type: http_method,
        dataType: "script",
        global: false,
        beforeSend: -> clearAndSpin()
      )

      fetch.then -> register_mark_as_read_event_listeners()
      fetch.error (request) ->
        if request.status >= 400
          $flash = $("<div></div>").addClass('flash').addClass('alert').addClass('alert-notice').text(request.responseText)
          $.getScript '/users/sign_in', ->
            $('#modalbox').prepend $flash
            $('#modalbox input[type=hidden].return_to').val window.location.pathname
          $notifications_list()
            .empty()


    $hub = -> $('li#notification-hub')

    $notifications_list = ->$('li#notification-hub .notifications')

    clearAndSpin = (clear=false) ->
      if clear
        $notifications_list().empty()
      $notifications_list().append($notif_spin = $('<div id="notifications-spinner"></div>'))
      $notif_spin.spin()

    $('a#notifications-count').on 'click', (e) ->
      send_update_notification_hub_request('/notifications', 'get')
