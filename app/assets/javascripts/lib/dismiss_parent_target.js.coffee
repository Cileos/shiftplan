jQuery(document).ready ->
  dismiss_parent_target = ->
    target = $(this).attr('data-dismiss')
    $(this).parents().each ->
      if $(this).attr('data-target') == target
        $(this).fadeOut()
        return

  $('body').on('click', '[data-dismiss]', dismiss_parent_target)
