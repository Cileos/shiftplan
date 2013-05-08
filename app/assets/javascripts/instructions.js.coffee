jQuery(document).ready ->
  title = $('#help').attr('title')
  $('#instructions').dialog
    autoOpen: false
    dialogClass: 'instructions-dialog'
    title: title
    resizable: false
    width: 300
    draggable: false

  $('#help').click ->
    $('#instructions').dialog( "open" )
