defaults =
  hint: true
  targetId: 'tutorial'
  appendTo: 'body'
  hintClass: 'tutorial-hint'

receiveFromIframe = null

$ = jQuery


# Applied to a link L, clicking on it will toggle the existance of an iframe
# containing the tutorial for L's data-name.
#
# Options:
#   hint: function getting the selector the tutorial wants to highlight
#   targetId: the DOMid of the inserted iframe
#   appendTo: selector/collection where the iframe is inserted into the DOM
#
# TODO: close button
$.fn.tutorialToggle = (options)->
  o = $.extend {}, defaults, options
  $hint = $('<div>').addClass(o.hintClass)

  hint = (actor, selector)->
    if $.isFunction actor
      actor(selector)
    else
      if actor? and o.hintClass?
        $('.' + o.hintClass).remove()

        $(selector).each ->
          $hint.
            clone().
            appendTo('body').
            position
              my: 'left center'
              at: 'right center'
              of: this
              collision: 'fit'

  open = ->
    $link = $(event.target).closest('a')
    name = $link.data('name')
    title = $link.attr('title')
    console?.debug "opening tutorial for", name
    url = "#{location.origin}/tutorial/#/chapter/#{name}"
    $container = $('<div></div>')
      .attr('id', o.targetId)
      .appendTo(o.appendTo)
    $('<iframe />')
      .attr('src', url)
      .mouseenter( -> $(@).addClass('hover') )
      .mouseleave( -> $(@).removeClass('hover') )
      .appendTo($container)

    unless receiveFromIframe
      receiveFromIframe = (event)->
        data = event.data
        if data[0] is 'hint'
          hint o.hint, data[1]

      addEventListener "message", receiveFromIframe, false

  close = ->
    if receiveFromIframe
      removeEventListener "message", receiveFromIframe, false
      receiveFromIframe = null
    $("#" + o.targetId)
      .remove()
    if o.hintClass?
      $('.' + o.hintClass).remove()

  $(this).click (event)->
    if $("#" + o.targetId).length is 0
      open()
    else
      close()

