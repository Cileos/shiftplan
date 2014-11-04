addNamesToDatepickerSelects = (picker, inst) ->
  picker.find('select.datepick-month-year').each ->
    $s = $(this)
    $s.attr('name', $s.attr('title'))

lastSessionTimeoutAt = null


translateOrDefault = (key, fallback)->
  if Ember.I18n.exists(key)
    Ember.I18n.t(key)
  else
    fallback

jQuery(document).ready ->
  $.ajaxSetup
    dataType: 'script'
    type: 'GET'

  # show sign in dialog in modal box when an AJAX request encounters a session timeout or other 401
  $(document).ajaxError (e, xhr, options)->
    if xhr.status == 401
      # mitigate too many failing requests
      if moment.duration(moment() - lastSessionTimeoutAt).asSeconds() > 15
        text = xhr.responseText
        if options.dataType.match(/json/)
          parsed = Ember.$.parseJSON(text)
          text = parsed.error
        $flash = $("<div></div>").addClass('flash').addClass('alert').text(text)
        $('.ui-dialog-content').remove() # close all existing modal boxes (Ember does them a little bit different)
        $.getScript '/users/sign_in', ->
          $('#modalbox').prepend $flash
          $('#modalbox input[type=hidden].return_to').val window.location.pathname

      lastSessionTimeoutAt = moment()

    if xhr.status == 403
      alert tranlateOrDefault('flash.ajax.error.403', '403 Access Denied')

    if xhr.status == 500
       alert translateOrDefault('flash.ajax.error.500', "500 Internal Server Error")

  language = $('html').attr('lang')
  $('body').on 'dialogopen', (e, ui) ->
    $(e.target).find('input.stringy_date').rails_datepick()
    $(e.target).find('input.stringy_week').rails_datepick
      week: true
      readonly: false
      prepend: true
      onSelect: (dates)->
        $(this).val( moment(dates[0]).format('YYYY/WW') )
    $(':input#team_color').minicolors({position: 'top left'})

  moment.locale(language)

  $.datepick.setDefaults $.extend( {},
    $.datepick.regional[ if language is 'en' then '' else language],
    {
      firstDay: 1,
      yearRange: 'c-5:c+8',
      renderer: $.extend {}, $.datepick.weekOfYearRenderer,
        picker: $.datepick.weekOfYearRenderer.picker
      onShow: $.datepick.multipleEvents(
        $.datepick.highlightWeek,
        addNamesToDatepickerSelects
      )
    }
  )

  $('body').find('input.stringy_date').rails_datepick()
