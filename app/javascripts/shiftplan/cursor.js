Cursor = {
  show: function(html_class) {
    var cursor = $('#cursor');
    if(cursor.length == 0) {
      cursor = $('body').append('<div id="cursor" class="' + html_class + '"></div>');
    }
    cursor.show();
  },
  hide: function() {
    $('#cursor').hide();
  },
  update_position: function(left, top) {
    $('#cursor').css({ left: left, top: top });
  },
  poof: function() {
    $('.poof').show()
    var top = 32;
    for(i = 1; i < 5; i++) {
      $('.poof').animate({ backgroundPosition: '0 ' + (top -= 32) + 'px' }, 80);
    }
    setTimeout("$('.poof').hide().css({ backgroundPosition: '0 0px' })", 5 * 80);
  }
};