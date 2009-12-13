$(document).ready(function() {
  $('li.resource, .resource .actions a.edit').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    var resource = $(this).closest('.resource')[0];
    var match = resource.id.match(/(.*)_(\d+)/);

    if(match && match[2]) {
      var resource_name = match[1];
      var id = parseInt(match[2]);
      var method = 'put';
      var path = '/' + resource_name + 's/' + id;
      var title = $('.name', $(resource)).html();
    } else {
      match = this.id.match(/new_(.*)/);
      var resource_name = match[1];
      var method = 'post';
      var path = '/' + resource_name + 's';
      var title = 'New ' + resource_name;
    }

    $('#sidebar form').attr('action', path);
    $('#sidebar > h3').html(title);

    $('#sidebar form input[name=_method]').attr('value', method);
    var form_values = eval('(' + $(resource).attr('data-form-values') + ')');

    $.each(form_values, function(name, value) {
      if($.isArray(value)) {
        $('.' + resource_name + '_' + name).val(value);
      } else {
        if(typeof value == 'boolean') { // assume that true/false goes for checkboxes
          $('#' + resource_name + '_' + name).attr('checked', value);
        } else if(name.match(/_date/)) {
          for(var i = 0; i < 3; i++) {
            $('#' + resource_name + '_' + name + '_' + (i + 1) + 'i').val(value.split('-')[i]);
          }
        } else if(name.match(/_time/)) {
          for(var i = 0; i < 3; i++) {
            $('#' + resource_name + '_' + name + '_' + (i + 4) + 'i').val(value.split(':')[i]);
          }
        } else {
          $('#' + resource_name + '_' + name).val(value);
        }
      }
    });

    $('#sidebar form').trigger({
      type: 'on_' + resource_name + '_load',
      resource: $(resource)
    });
  });
});
