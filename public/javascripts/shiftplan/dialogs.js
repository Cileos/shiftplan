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

var createDialogForLink = function(link) {
  var dialogContainer = $('<div id="dialog"></div>');
  dialogContainer.dialog({
    width:800,
    title: link.attr('title'),
    close: function() {
      link.dialog('destroy');
    }
  });

  $.ajax({
    url: link.attr('href'),
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
};

$(document).ready(function() {
  $('a.dialog').live('click', function(event) {
    event.preventDefault();
    createDialogForLink($(this));
  });
});