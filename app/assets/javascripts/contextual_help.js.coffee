jQuery(document).ready ->
  return if $('#contextual_help').length == 0

  checkStatus = (e, id) ->
    if e.hasClass('content-hidden')
      e.attr('data-icon', "")
      false
    else
      e.attr('data-icon', "")
      false

  $('#contextual_help > div').each ->
    $(this).find('a[id^="toggle_"]').click ->
      id = $(this).parents('div').first()
      id.children(':not(h4)').slideToggle()
      $(this).toggleClass('content-hidden')
      checkStatus($(this), id)
