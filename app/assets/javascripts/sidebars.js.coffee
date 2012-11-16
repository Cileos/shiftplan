jQuery(document).ready ->
  return if $('#calendar').length == 0

  setIcon = (lnk, id) ->
    icon_left = ""
    icon_right  = ""
    if ((id == 'sidebar' && lnk.hasClass('collapsed')) || (id == 'contextual_help' && !lnk.hasClass('collapsed')))
      lnk.attr('data-icon', icon_right)
    else
      lnk.attr('data-icon', icon_left)

  updateWidths = ->
    # sidebar width: 14.70196% # from neat css
    small_width = '65.88078%'  # from neat css
    medium_width = '80%'
    full_width = '96%'

    # # enable this as soon as we have 2 sidebars again
    # cnt = $('#toggle_sidebar').hasClass('collapsed') ? 1 : 0
    # cnt += $('#toggle_contextual_help').hasClass('collapsed') ? 1 : 0
    # wdth = switch (cnt)
      # when 2 then full_width
      # when 1 then medium_width
      # else small_width

    # $('.primary').css('width', wdth)
    # if $('#toggle_contextual_help').hasClass('collapsed')
    #   $('.primary').css('margin-right', '1%')
    # else
    #   $('.primary').css('margin-right', '')
    # # end enable this as soon as we have 2 sidebars again

    # # disable this as soon as we have 2 sidebars again
    wdth = ''
    if $('#toggle_sidebar').hasClass('collapsed')
      wdth = full_width
    $('.primary').css('width', wdth)
    # # end disable this as soon as we have 2 sidebars again

  toggleSidebars = (e) ->
    id = e.attr('id')
    lnk = $('[role="content"]').find('#toggle_'+id)
    e.toggleClass('collapsed')
    lnk.toggleClass('collapsed')
    if e.hasClass('collapsed')
      setIcon(lnk, id)
      e.css('width', '0')
       .css('padding-right', '0')
       .css('padding-left', '0')
       .css('overflow', 'hidden')
       .css('border-right', 'none')
      updateWidths(e)
      $.cookie('clockwork_'+id, 'collapsed', { path: '/' })
      false
    else
      setIcon(lnk, id)
      e.css('width', '')
       .css('padding-right', '')
       .css('padding-left', '')
       .css('overflow', '')
       .css('border-right', '')
      updateWidths(e, 'restore')
      $.cookie('clockwork_'+id, 'visible', { path: '/' })
      false

  calcPercentage = (val) ->
    width = 100 * parseFloat(parseFloat(val) / parseFloat($('[role="content"]').css('width')) ) + '%';

  # $('#sidebar, #contextual_help').each ->
  $('#sidebar').each ->
    e = $(this)
    id = e.attr('id')
    $('[role="content"]').prepend('<a href="#" id="toggle_'+id+'" data-toggle="'+id+'" class="toggle-sidebars utility-button" data-icon="x">')
    lnk = $('[role="content"]').find('#toggle_'+id)
    if $.cookie('clockwork_'+e.attr('id')) == 'collapsed'
      $('[role="content"]').addClass('no-animation')
      toggleSidebars(e)
    setIcon(lnk, id)
    lnk.click ->
      $('[role="content"]').removeClass('no-animation')
      toggleSidebars(e)
