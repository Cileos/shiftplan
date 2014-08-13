jQuery(document).ready ->
  if $('#instructions').length == 0
    $('#help').hide()
  else
    title = $('#help').attr('title')
    $('#instructions').hide()
