jQuery(document).ready ->
  return if $('#page .help').length == 0

  $('#actions').append('<div class="btn-group pull-right"><div id="display_help" class="js_button btn display_help" title="Hilfe anzeigen">Hilfe</i></div></div>')

  $('.help').dialog({autoOpen: false, minWidth: 500, modal: false})

  $('#display_help').click ->
    $('.help').dialog('open')
