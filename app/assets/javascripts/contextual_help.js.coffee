jQuery(document).ready ->
  return if $('#contextual_help').length == 0

  updateStatus = (e, id) ->
    if e.hasClass('content-hidden')
      e.attr('data-icon', "")
      $.cookie('shiftplan_'+id, 'hidden', { path: '/' })
      false
    else
      e.attr('data-icon', "")
      $.cookie('shiftplan_'+id, 'visible', { path: '/' })
      false

  toggleVisiblity = (e, speed='instant') ->
    container = e.parents('div').first()
    if speed != 'slide'
      container.children(':not(h4)').toggle()
    else
      container.children(':not(h4)').slideToggle()
    e.toggleClass('content-hidden')
    updateStatus(e,container.attr('id'))

  $('#contextual_help > div').each ->
    link = $(this).find('a[id^="toggle_"]')
    if $.cookie('shiftplan_'+$(this).attr('id')) == 'hidden'
      toggleVisiblity(link)
    link.click ->
      toggleVisiblity($(this), 'slide')
