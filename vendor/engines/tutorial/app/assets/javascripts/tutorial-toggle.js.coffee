window.toggleTutorial = (options)->
  hint = options.hint || Ember.K

  (event)->
    name = $(event.target).closest('a').data('name')
    if jQuery("#tutorial").length is 0
      console?.debug "opening tutorial for", name
      url = "#{location.origin}/tutorial/#/chapter/#{name}"
      jQuery('<iframe />').attr('id', 'tutorial').attr('src', url).appendTo('section[role=content]')

      receiveFromIframe = (event)->
        data = event.data
        if data[0] is 'hint'
          selector = data[1]
          hint(selector)

      addEventListener "message", receiveFromIframe, false
    else
      jQuery("#tutorial").remove()

