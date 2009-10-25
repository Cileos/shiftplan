// borrowed from http://codetunes.com/2008/12/08/rails-ajax-and-jquery/
jQuery(document).ready(function() {
  jQuery("body").bind('ajaxSend', function(elm, xhr, s) {
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
    dataType: 'json',
    // xhr put request should work with htmlunit, but they actually never get sent
    // for now will use rails' tunneling instead
    // beforeSubmit: function(form_data, form, options) {
    //   options['type'] = form.attr('action').match(/.*\d+$/) ? 'PUT' : 'POST';
    //   return true;
    // },
    success: function(data, textStatus) {
      // HTML snippets
      if(data['html']['append']) {
        $.each(data['html']['append'], function(element, html) {
          $(html).css('display', 'none').appendTo($(element)).effect('fold', { mode: 'show' }, 1000).effect('highlight', {}, 1000);
        });
      }

      document.title = ''
      if(data['html']['replace']) {
        $.each(data['html']['replace'], function(element, html) {
          // $(html).css('display', 'none').replaceAll($(element)).effect('highlight', {}, 1000);
          $(html).replaceAll($(element));
        });
      }
    }
  });
});
