defaults =
  hint: Ember.K
  targetId: 'tutorial'
  appendTo: 'body'

# Applied to a link L, clicking on it will toggle the existance of an iframe
# containing the tutorial for L's data-name.
#
# Options:
#   hint: function getting the selector the tutorial wants to highlight
#   targetId: the DOMid of the inserted iframe
#   appendTo: selector/collection where the iframe is inserted into the DOM
jQuery.fn.tutorialToggle = (options)->
  o = jQuery.extend {}, defaults, options

  jQuery(this).click (event)->
    name = $(event.target).closest('a').data('name')
    if jQuery("#" + o.targetId).length is 0
      console?.debug "opening tutorial for", name
      url = "#{location.origin}/tutorial/#/chapter/#{name}"
      jQuery('<iframe />').attr('id', o.targetId).attr('src', url).appendTo(o.appendTo)

      receiveFromIframe = (event)->
        data = event.data
        if data[0] is 'hint'
          selector = data[1]
          o.hint(selector)

      addEventListener "message", receiveFromIframe, false
    else
      jQuery("#" + o.targetId).remove()

