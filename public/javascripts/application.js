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
    s.data = s.data + encodeURIComponent(window._auth_token_name)
                    + '=' + encodeURIComponent(window._auth_token);
  });
});