jQuery(document).ready ->
  return if $('#help').length == 0

  $('#help').dialog({autoOpen: false, minWidth: 500, modal: false})

  $('#display_help').click -> $('#help').dialog('open')
