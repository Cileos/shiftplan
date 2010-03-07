// borrowed from http://codetunes.com/2008/12/08/rails-ajax-and-jquery/
$(document).ready(function() {
  $('.activity > a').click(function() {
    $('table', $(this).closest('.activity')).each(function() { $(this).toggle(); });
    return false;
  });
  
  $("body").bind('ajaxSend', function(elm, xhr, s) {
    if (s.type == 'GET') return;
    if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + '='))) return;
    if (s.data) {
      s.data = s.data + '&';
    } else {
      s.data = '';
      // if there was no data, $ didn't set the content-type
      xhr.setRequestHeader('Content-Type', s.contentType);
    }
    s.data += encodeURIComponent(window._auth_token_name) + '=' +
              encodeURIComponent(window._auth_token);
  });

  $('#sidebar form').ajaxForm({
    dataType: 'text',
    // xhr put request should work with htmlunit, but they actually never get sent
    // for now will use rails' tunneling instead
    // beforeSubmit: function(form_data, form, options) {
    //   options['type'] = form.attr('action').match(/.*\d+$/) ? 'PUT' : 'POST';
    //   return true;
    // },
    success: function(data, textStatus) {
      data = eval("(" + data + ")");

      // reset form
      $('#sidebar form').each(function() { this.reset(); });
      $('#staff_requirements').each(function() { $(this).empty(); })
      $('#copy_from_options').hide();

      if(data['html']['append']) {
        $.each(data['html']['append'], function(element, html) {
          // folding does not work well with table rows
          // $(html).css('display', 'none').appendTo($(element)).effect('fold', { mode: 'show' }, 1000).effect('highlight', {}, 1000);
          $(html).appendTo($(element)).effect('highlight', {}, 1000);
        });
      }

      if(data['html']['replace']) {
        $.each(data['html']['replace'], function(element, html) {
          // $(html).css('display', 'none').replaceAll($(element)).effect('highlight', {}, 1000);
          $(html).replaceAll($(element)).effect('highlight', {}, 1000);
        });
      }

      if(data['flash']) {
        $.each(data['flash'], function(type, message) {
          if(message != '') {
            $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
          }
        });
      }
    }
  });

  $('form #copy_from_id').change(function() {
    if($(this).val() == '') {
      $('#copy_from_options').hide();
    } else {
      $('#copy_from_options').show();
    }
  });
});

(function($) {  
  $.fn.outerHTML = function() {
    return $('<div>').append( this.eq(0).clone() ).html();
  };
  
  $.fn.delay = function(time, name) {
    return this.queue((name || "fx"), function() {
      var self = this;
      setTimeout(function() { $.dequeue(self); } , time );
    });
  };
})(jQuery);