$(document).ready(function() {
  $('#page:has("#calendar")').addClass('calendar');
  $('#calendar').before('<div id="max_min_calendar" class="js_button expandable" title="Maximieren/Minimieren"></div>');
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
