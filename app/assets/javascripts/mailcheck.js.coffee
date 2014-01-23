jQuery(document).ready ->

  $('input.mailcheck').on 'blur', ->
    $input = $(this)
    mailcheck_hint = $(this).data('mailcheck-hint')
    $(this).mailcheck
      suggested: (element, suggestion) ->
        $('span.mailcheck-suggestion').remove()
        $suggestion = $('<span></span>')
          .addClass('help-inline')
          .addClass('mailcheck-suggestion')
          .html(mailcheck_hint + " <a href='#'>" + suggestion.full + "</a>?")
          .click (event)->
            event.preventDefault()
            $input.val suggestion.full
            $suggestion.remove()

        $(element).parent().append($suggestion)

      empty: (element) ->
        $('span.mailcheck-suggestion').remove()

