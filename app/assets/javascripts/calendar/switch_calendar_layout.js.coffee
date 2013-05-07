jQuery(document).ready ->
  return if $('#page #calendar').length == 0

  # FIXME extract into template, use i18n
  $('#actions').append('<div class="btn-group pull-right"><div id="calendar_detail_level" class="js_button btn btn-inverse detail_level" title="Detail Level umstellen"><i class="icon-th-list icon-white"></i></div><div id="max_min_calendar" class="js_button btn btn-inverse expandable" title="Maximieren/Minimieren"><i class="icon-resize-full icon-white"></i></div></div>')

  page = $('#page')
  btn_max = $('#max_min_calendar.js_button.expandable')
  btn_detail = $('#calendar_detail_level.js_button.detail_level')

  setWidth = (obj, swtch) ->
    switch swtch
      when 'max'
        # min-width has to be resetted to enable resize for shrinking viewport
        obj.css('min-width', '')
           .css('min-width', page.width())
           .css('max-width', $(window).width())
        $.cookie('cal_width_max', 'true', { path: '/' })
      when 'initial'
        obj.css('min-width', '')
           .css('max-width', '')
      else
        false

  checkPageWidth = ->
    w = $(window).width()
    if w < '1110'
      btn_max.addClass('disabled')
      page.removeClass('expanded')
      setWidth(page, 'initial')
    else
      btn_max.removeClass('disabled')
      if btn_max.hasClass('active')
        page.addClass('expanded')
        setWidth(page, 'max')
    if w < '800'
      btn_detail.addClass('disabled')
    else
      btn_detail.removeClass('disabled')

  # toggle calendar layout (normal/condensed)
  btn_detail.click ->
    page.toggleClass('detail_condensed')
    $(this).toggleClass('active condensed')
    if $.cookie('cal_condensed') == 'true'
      $.cookie('cal_condensed', 'false', { path: '/' })
    else
      $.cookie('cal_condensed', 'true', { path: '/' })

  # maximize calendar
  btn_max.click ->
    page.addClass('effect')
    if $(this).hasClass('expanded')
      setWidth(page, 'initial')
      $.cookie('cal_width_max', 'false', { path: '/' })
    else
      setWidth(page, 'max')
    page.toggleClass('expanded')
    $(this).toggleClass('active expanded')


  page.addClass('calendar')

  if $.cookie('cal_condensed') == 'true'
    page.addClass('detail_condensed')
    btn_detail.addClass('active condensed')

  if $.cookie('cal_width_max') == 'true'
    setWidth(page, 'max')
    page.addClass('expanded')
    btn_max.addClass('active expanded')

  checkPageWidth()

  $(window).resize ->
    page.removeClass('effect')
    checkPageWidth()