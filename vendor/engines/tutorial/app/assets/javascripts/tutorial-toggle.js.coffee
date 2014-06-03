window.toggleTutorial = (event)->
  name = $(event.target).closest('a').data('name')
  if jQuery("#tutorial").length is 0
    console?.debug "opening tutorial for", name
    url = "#{location.origin}/tutorial/#/chapter/#{name}"
    jQuery('<iframe />').attr('id', 'tutorial').attr('src', url).appendTo('section[role=content]')
  else
    jQuery("#tutorial").remove()

