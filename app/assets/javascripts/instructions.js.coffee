jQuery(document).ready ->
  if $('#instructions').length == 0
    $('#help').hide()
  else
    title = $('#help').attr('title')
    $('#instructions').dialog
      autoOpen: false
      dialogClass: 'instructions-dialog'
      title: title
      resizable: true
      width: 300
      draggable: true
      height: 400
      position: ['right',65]

    $('#help').click ->
      $('#instructions').dialog( "open" )
