// {
//   'flash': {
//     'notice': 'Muh',
//     'error': 'Mäh'
//   }
//   'employee': {
//     'errors': {
//       'first_name': "can't be blank"
//     }
//   }
// }

Array.prototype.toSentence = function() {
  return this.join(', ');
};

var handleSuccessfulDialogFormRequest = function(data, textStatus) {
  alert(data);
};

var handleFailedDialogFormRequest = function(request, statusText, error) {
  var data = $.httpData(request, 'json', {});

  // unwrap all errors
  // FIXME: keep values
  $('div.fieldWithErrors').each(function() {
    $(this).replaceWith($(this).html());
  });
  $('span.form_error_message').remove();

  $.each(data['errors'], function(object_name, fieldsWithErrors) {
    $.each(fieldsWithErrors, function(field_name, errors) {
      var selector = $('#' + object_name + '_' + field_name);
      var errorMessagesSpan = '<span class="form_error_message">' + errors.toSentence() + '</span>';
      if(selector.parent('div.fieldWithErrors').length < 1) {
        selector.wrap('<div class="fieldWithErrors"></div>').parent('div.fieldWithErrors').after(errorMessagesSpan);
      }
      selector.parent('div.fieldWithErrors').siblings('span.form_error_message').replaceWith(errorMessagesSpan);
    });
  });
};

$(document).ready(function() {
  $('a.dialog').live('click', function(event) {
    event.preventDefault();

    var dialogContainer = $('<div id="dialog"></div>');
    dialogContainer.dialog({
      width:800,
      title: this.title,
      close: function() {
        $(this).dialog('destroy').remove();
      }
    });
  
    $.ajax({
      url: this.href,
      dataType: 'html',
      success: function(data, textStatus) {
        dialogContainer.html(data);
        $('#dialog form').ajaxForm({
          dataType: 'json',
          success: handleSuccessfulDialogFormRequest,
          error: handleFailedDialogFormRequest
        });
      }
    });
  });
});