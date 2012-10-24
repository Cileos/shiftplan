jQuery(document).ready ->
  $.ajaxSetup
    dataType: 'script'
    type: 'GET'

  $(document).ajaxError (e, xhr, options)->
    if xhr.status == 401
      $flash = $("<div></div>").addClass('flash').addClass('alert').addClass('alert-notice').text(xhr.responseText)
      $.getScript '/users/sign_in', ->
        $('#modalbox').prepend $flash
        $('#modalbox input[type=hidden].return_to').val window.location.pathname

  $('body').on 'dialogopen', (e, ui) ->
    locale = $('meta[name=locale]').attr('content')
    $(e.target).find('input.stringy_date').datepicker($.datepicker.regional[locale])
