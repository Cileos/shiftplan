jQuery(document).ready ->

  $('body').on 'click', 'ul.comments a.reply', (event) ->
    event.preventDefault()
    event.stopPropagation()

    $link = $(this)
    $link.closest('ul.comments').parent().find('form.new_comment')
      .clone()
      .addClass('reply')
      .find('button[type=submit]')
        .html( $link.html() )
      .end()
      .find('input[name="comment[parent_id]"]')
        .val( $link.attr('href').match(/(\d+)/)[1] )
      .end()
      .appendTo($link.parent())
    $link.remove()

    false


