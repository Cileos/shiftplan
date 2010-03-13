$(document).ready(function() {
  $('.resource .actions a.delete').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    var resource = $(this).closest('.resource')[0];
    var match = resource.id.match(/(.*)_(\d+)/);
    var resource_name = match[1];

    if(resource_name == 'plan') { // yuck FIXME
      var url = '/plans/' + match[2];
  	  var data = '_method=delete';

  	  $.ajax({
  		  'url': url,
  		  'type': 'post', // seems like HTMLUnit doesn't allow DELETE requests to have parameters ...
  		  'data': data,
  		  'dataType': 'text',
  		  'success': function(data, textStatus) {
  		    $(resource).remove();
          data = eval("(" + data + ")");
          if(data['flash']) {
            $.each(data['flash'], function(type, message) {
              if(message != '') {
                $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
              }
            });
          }
        }
  		});
    } else {
      $(resource)[resource_name]().destroy();
      $(resource).remove();
    }
  });

  // $('li.resource, .resource .actions a.edit')
  $('li.resource, .resource .actions a.edit, .resource .actions a.add').live('click', function(event) {
    if(event.isPropagationStopped()) return; // wtf?

    event.preventDefault();
    event.stopPropagation();

    var resource = $(this).closest('.resource')[0];
    var match = resource.id.match(/(.*)_(\d+)/);

    if(match != null && match[2]) {
      var resource_name = match[1];
      var id = parseInt(match[2]);
      var method = 'put';
      var title = $('.name', $(resource)).html();
    } else {
      match = this.id.match(/new_(.*)/);
      var resource_name = match[1];
      var method = 'post';
      var title = 'New ' + resource_name;
    }

    var match = $('#sidebar form').attr('action').match(/^\/([a-zA-Z\-_]*)/);
    var path = '/' + match[1];
    if(id) path += '/' + id;

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
        } else if(name == 'day' || name.match(/_date/)) {
          for(var i = 0; i < 3; i++) {
            $('#' + resource_name + '_' + name + '_' + (i + 1) + 'i').val(parseInt(value.split('-')[i], 10));
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
