$(document).ready(function() {
  $('li.resource').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    // find link with class 'clickable_link' and open a dialog for it
    // createDialogForLink($('a.clickable_link', $(this)));
    var match = this.id.match(/(.*)_(\d+)/);

    if(match && match[2]) {
      var resource_name = match[1];

      var id = parseInt(match[2]);
      var path = '/' + resource_name + 's/' + id;
    } else {
      match = this.id.match(/new_(.*)/);
      var resource_name = match[1];
      var path = '/' + resource_name + 's';
    }

    $('#sidebar form').attr('action', path);
    $('#sidebar form > fieldset > legend').html($('h2 a, a.edit', $(this)).attr('title')); // ugh

    var form_values = eval('(' + $(this).attr('data-form-values') + ')');
    $.each(form_values, function(field, value) {
      if($.isArray(value)) {
        $('.' + resource_name + '_' + field).val(value);
      } else {    
        var field = $('#' + resource_name + '_' + field);

        if(typeof value == 'boolean') { // assume that true/false goes for checkboxes
          field.attr('checked', value);
        } else {
          field.val(value);
        }
      }
    });
  });
});