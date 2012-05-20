$(document).ready(function() {
  $('#page:has("#calendar")').addClass('calendar');
  $('#actions').append('<div class="btn-group pull-right"><div id="calendar_detail_level" class="js_button btn btn-inverse detail_level" title="Detail Level umstellen"><i class="icon-th-list icon-white"></i></div><div id="max_min_calendar" class="js_button btn btn-inverse expandable" title="Maximieren/Minimieren"><i class="icon-resize-full icon-white"></i></div></div>');

  var checkPageWidth = function() {
      var w = $(window).width();
      if (w < '1110') {
        btn_max.addClass('disabled');
        btn_max.removeClass('active expanded');
        page.removeClass('expanded').css('min-width', '').css('max-width', '');
      } else {
        btn_max.removeClass('disabled');
      }
      if (w < '800') {
        btn_detail.addClass('disabled');
      } else {
        btn_detail.removeClass('disabled')
      };
  }

  // maximize calendar
  var btn_max = $('#max_min_calendar.js_button.expandable');
  var page = $('#page');
  btn_max.click(function(){
    var page_min_width = page.css('min-width');
    var page_max_width = page.css('max-width');

    if (page.hasClass('expanded')) {
      page.css('min-width', '')
          .css('max-width', '');
    }
    else {
      page.css('min-width', page.width())
          .css('max-width', $(window).width());
    }
    page.toggleClass('expanded');
    $(this).toggleClass('active expanded');
  });

  // toggle calendar layout (normal/condensed)
  var btn_detail = $('#calendar_detail_level.js_button.detail_level');
  btn_detail.click(function(){
    $('#page').toggleClass('detail_condensed')
    $(this).toggleClass('active condensed');
  });

  checkPageWidth();
  $(window).resize(function(){
    checkPageWidth();
  });
});


// icon-th-large
// icon-th-list
