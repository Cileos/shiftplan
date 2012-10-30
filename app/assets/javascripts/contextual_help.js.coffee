jQuery(document).ready ->

  toggleVisiblity = (e) ->
    coll_head = e.children('[data-toggle="collapsible-heading"]')
    coll_cont = e.children('[data-toggle="collapsible-content"]')

    coll_head.toggleClass('collapsed')
    coll_cont.toggleClass('collapsed')

    if coll_head.hasClass('collapsed')
      coll_head.attr('data-icon', "")
      $.cookie('shiftplan_'+e.attr('id'), 'collapsed', { path: '/' })
      false
    else
      coll_head.attr('data-icon', "")
      $.cookie('shiftplan_'+e.attr('id'), 'visible', { path: '/' })
      false

  $('[data-toggle="collapsible"]').each ->
    e = $(this)
    if $.cookie('shiftplan_'+e.attr('id')) == 'collapsed'
      toggleVisiblity(e)
    e.children('[data-toggle="collapsible-heading"]').click ->
      toggleVisiblity(e)
