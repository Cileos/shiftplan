jQuery(document).ready ->
  $.ajaxSetup
    dataType: 'script'
    type: 'GET'

  # show sign in dialog in modal box when an AJAX request encounters a session timeout or other 401
  $(document).ajaxError (e, xhr, options)->
    if xhr.status == 401
      text = xhr.responseText
      if options.contentType.match(/json/)
        parsed = Ember.$.parseJSON(text)
        text = parsed.error
      $flash = $("<div></div>").addClass('flash').addClass('alert').text(text)
      $.getScript '/users/sign_in', ->
        $('#modalbox').prepend $flash
        $('#modalbox input[type=hidden].return_to').val window.location.pathname

  language = $('html').attr('lang')
  $('body').on 'dialogopen', (e, ui) ->
    $(e.target).find('input.stringy_date').datepicker($.datepicker.regional[language])
    $(':input#team_color').minicolors()

  $.datepick.setDefaults $.datepick.regional[ if language is 'en' then '' else language]
