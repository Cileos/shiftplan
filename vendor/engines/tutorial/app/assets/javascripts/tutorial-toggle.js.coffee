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
# TODO: extract dialog functionality
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

  close = ->
    if receiveFromIframe
      removeEventListener "message", receiveFromIframe, false
      receiveFromIframe = null
    $("#" + o.targetId)
      .remove()
    if o.hintClass?
      $('.' + o.hintClass).remove()

  open = ->
    $link = $(event.target).closest('a')
    name = $link.data('name')
    title = $link.attr('title')
    close_label = $link.data('close-label')
    console?.debug "opening tutorial for", name
    url = "#{location.origin}/tutorial/#/chapter/#{name}"
    $container = $('<div></div>')
      .attr('id', o.targetId)
      .addClass('dialog')
    $('<a></a>')
      .addClass('close-button')
      .attr('href', '#')
      .text(close_label)
      .click(close)
      .appendTo($container)
    $('<h4></h4>')
      .text(title)
      .appendTo($container)
    $iframe = $('<iframe />')
      .attr('src', url)
      .appendTo($container)

    $iframeFix = $('<div></div>')
      .addClass('iframeFix')

    $container
      .appendTo(o.appendTo)
      .draggable
        start: (event, ui)->
          $iframeFix
            .clone()
            .css
              position: 'absolute'
              width: $iframe.width()
              height: $iframe.height()
              bottom: 0
              left: 0
            .appendTo($container)

        stop: (event, ui)->
          $container.find('.iframeFix').remove()


    unless receiveFromIframe
      receiveFromIframe = (event)->
        data = event.data
        if data[0] is 'hint'
          hint o.hint, data[1]

      addEventListener "message", receiveFromIframe, false

  $(this).click (event)->
    if $("#" + o.targetId).length is 0
      open()
    else
      close()

