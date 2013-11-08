jQuery(document).ready ->
  return if $('#sidebar').length == 0

  updateWidths = ->
    if $('#toggle_sidebar').hasClass('collapsed')
      $('[role=content]').css('margin-left', '0')
                         .css('padding-left', '15px')
    else
      $('[role=content]').css('margin-left', '')
                         .css('padding-left', '')

  toggleSidebars = ($elem) ->
    id = $elem.attr('id')
    lnk = $('body').find('#toggle_'+id)
    $elem.toggleClass('collapsed')
    lnk.toggleClass('collapsed')
    if $elem.hasClass('collapsed')
      $elem.hide()
      updateWidths()
      $.cookie('clockwork_'+id, 'collapsed', { path: '/' })
      false
    else
      $elem.show()
      updateWidths()
      $.cookie('clockwork_'+id, 'visible', { path: '/' })
      false

  $('#sidebar').each ->
    $elem = $(this)
    id = $elem.attr('id')
    $('[role=aside]').after('<a href="#" id="toggle_'+id+'" data-toggle="'+id+'" class="toggle-sidebars utility-button button-inverted">')
    lnk = $('body').find('#toggle_'+id)
    if $.cookie('clockwork_'+$elem.attr('id')) == 'collapsed'
      $('[role="content"]').addClass('no-animation')
      toggleSidebars($elem)
    lnk.click ->
      $('[role="content"]').removeClass('no-animation')
      toggleSidebars($elem)
