jQuery(document).ready ->
  return if $('#page #calendar').length == 0

  $('#actions').append('<div class="btn-group pull-right"><div id="calendar_detail_level" class="js_button btn btn-inverse detail_level" title="Detail Level umstellen"><i class="icon-th-list icon-white"></i></div><div id="max_min_calendar" class="js_button btn btn-inverse expandable" title="Maximieren/Minimieren"><i class="icon-resize-full icon-white"></i></div></div>')

  page = $('#page')
  btn_max = $('#max_min_calendar.js_button.expandable')
  btn_detail = $('#calendar_detail_level.js_button.detail_level')

  checkPageWidth = ->
    w = $(window).width()
    if w < '1110'
      btn_max.addClass('disabled')
      page.removeClass('expanded')
          .css('min-width', '')
          .css('max-width', '')
    else
      btn_max.removeClass('disabled')
      if btn_max.hasClass('active')
        page.addClass('expanded')
            .css('min-width', page.width())
            .css('max-width', $(window).width())
    if w < '800'
      btn_detail.addClass('disabled')
    else
      btn_detail.removeClass('disabled')


  # toggle calendar layout (normal/condensed)
  btn_detail.click ->
    page.toggleClass('detail_condensed')
    $(this).toggleClass('active condensed')


  # maximize calendar
  btn_max.click ->
    page.addClass('effect')
    page_min_width = page.css('min-width')
    page_max_width = page.css('max-width')

    if $(this).hasClass('expanded')
      page.css('min-width', '')
          .css('max-width', '')
    else
      page.css('min-width', page.width())
          .css('max-width', $(window).width())
    page.toggleClass('expanded')
    $(this).toggleClass('active expanded')


  page.addClass('calendar')
  checkPageWidth()
  $(window).resize ->
    page.removeClass('effect')
    checkPageWidth()
