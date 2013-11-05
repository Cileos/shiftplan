jQuery(document).ready ->
  return if $('#calendar').length == 0

  updateWidths = ->
    # sidebar width: 14.70196% # from neat css
    small_width = '65.88078%'  # from neat css
    medium_width = '80%'
    full_width = '99%'

    if $('#toggle_sidebar').hasClass('collapsed')
      $('[role=content]').css('margin-left', '0')
                         .css('padding-left', '15px')
    else
      $('[role=content]').css('margin-left', '')
                         .css('padding-left', '')

  toggleSidebars = (e) ->
    id = e.attr('id')
    lnk = $('body').find('#toggle_'+id)
    e.toggleClass('collapsed')
    lnk.toggleClass('collapsed')
    if e.hasClass('collapsed')
      e.hide()
      updateWidths(e)
      $.cookie('clockwork_'+id, 'collapsed', { path: '/' })
      false
    else
      e.show()
      updateWidths(e, 'restore')
      $.cookie('clockwork_'+id, 'visible', { path: '/' })
      false

  $('#sidebar').each ->
    e = $(this)
    id = e.attr('id')
    $('.where-and-who-am-i').prepend('<a href="#" id="toggle_'+id+'" data-toggle="'+id+'" class="toggle-sidebars utility-button">')
    lnk = $('body').find('#toggle_'+id)
    if $.cookie('clockwork_'+e.attr('id')) == 'collapsed'
      $('[role="content"]').addClass('no-animation')
      toggleSidebars(e)
    lnk.click ->
      $('[role="content"]').removeClass('no-animation')
      toggleSidebars(e)
