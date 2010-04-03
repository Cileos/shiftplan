$(document).ready(function() {
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

      if(data['html']) {
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
});
