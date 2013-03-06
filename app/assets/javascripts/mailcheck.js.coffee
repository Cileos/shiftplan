jQuery(document).ready ->

  $('input.mailcheck').on 'blur', ->
    mailcheck_hint = $(this).data('mailcheck-hint')
    $(this).mailcheck
      suggested: (element, suggestion) ->
        $('span.mailcheck-suggestion').remove()
        $(element).parent().append(
          "<span class='help-inline mailcheck-suggestion'>" +
            mailcheck_hint + " <a href='#'>" + suggestion.full + "</a>?</span>")

      empty: (element) ->
        $('span.mailcheck-suggestion').remove()

  $('span.mailcheck-suggestion a').live 'click', (event) ->
    event.preventDefault()
    $("#user_email").val $(this).text()
    $('span.mailcheck-suggestion').remove()

