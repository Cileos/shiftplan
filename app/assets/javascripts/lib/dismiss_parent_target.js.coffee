# Clicking a link with data-dismiss of "foo" should dismiss (close) closest
# parent with data-target of "foo". Used for Flash messages.
jQuery(document).ready ->
  dismiss_parent_target = ->
    target = $(this).attr('data-dismiss')
    $(this).parents().each ->
      if $(this).attr('data-target') == target
        $(this).fadeOut()
        return

  $('body').on('click', 'a[data-dismiss]', dismiss_parent_target)
