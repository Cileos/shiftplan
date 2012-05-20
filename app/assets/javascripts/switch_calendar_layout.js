$(document).ready(function() {
  $('#page:has("#calendar")').addClass('calendar');
  $('#actions').append('<div class="btn-group pull-right"><div id="calendar_detail_level" class="js_button btn btn-inverse detail_level" title="Detail Level umstellen"><i class="icon-th-large icon-white"></i></div><div id="max_min_calendar" class="js_button btn btn-inverse expandable" title="Maximieren/Minimieren"><i class="icon-resize-full icon-white"></i></div></div>');
  $('#max_min_calendar.js_button.expandable').click(function(){
    var page = $('#page');
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
    $(this).toggleClass('expanded');
  });
});


// icon-th-large
// icon-th-list
