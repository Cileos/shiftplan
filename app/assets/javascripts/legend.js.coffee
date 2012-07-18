jQuery(document).ready ->
  return if $('#legend').length == 0

  $('#actions').append('<div class="btn-group pull-right"><div id="display_legend" class="js_button btn display_legend" title="Legende anzeigen">Legende</i></div></div>')

  $('#legend').dialog({autoOpen: false, minWidth: 500, modal: false})

  $('#display_legend').click ->
    $('#legend').dialog('open')
