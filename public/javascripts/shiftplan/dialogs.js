var handleSuccessfulDialogFormRequest = function(data, textStatus) {
  updateFlash(data['flash']);

  var form = $('#dialog form')[0];
  var match_data = form.id.match(/(new|edit)_([^0-9]+)(_[0-9]+)?$/);
  var type = match_data[1];
  var object = match_data[2];

  $.each(data[object], function(attribute, value) {
    var form_field = $('#' + object + '_' + attribute);
    if(form_field.length > 0) {
      form_field.val(value);
    }
  });

  // update form
  var form_object = $(form)
  form_object.attr('id', 'edit_' + object + '_' + data[object]['id']).
    addClass('edit_' + object).removeClass('new_' + object);
  if(type == 'new') { // new form needs new URL, too
    form_object.attr('action', form_object.attr('action') + '/' + data[object]['id']);
  }

  // add hidden field for PUT request
  $('input[type=hidden][name=_method]', form_object).remove();
  $('div:first-child', form_object).append('<input type="hidden" name="_method" value="put" />');
};

var updateFlash = function(flashes) {
  $.each(flashes, function(type, message) {
    if(message == '') return;

    var flash = $('#flash');
    flash.html(message);
    flash.attr('class', type);
    flash.show();
  });
};

var handleFailedDialogFormRequest = function(request, statusText, error) {
  var data = $.httpData(request, 'json', {});

  updateFlash(data['flash']);

  // unwrap all errors
  // FIXME: keep values
  $('div.fieldWithErrors').each(function() {
    $(this).replaceWith($(this).html());
  });
  $('span.formErrorMessage').remove();

  $.each(data['errors'], function(object_name, fieldsWithErrors) {
    $.each(fieldsWithErrors, function(field_name, errors) {
      var selector = $('#' + object_name + '_' + field_name);
      var errorMessagesSpan = '<span class="formErrorMessage">' + errors.toSentence() + '</span>';
      if(selector.parent('div.fieldWithErrors').length < 1) {
        selector.wrap('<div class="fieldWithErrors"></div>').parent('div.fieldWithErrors').after(errorMessagesSpan);
      }
      selector.parent('div.fieldWithErrors').siblings('span.formErrorMessage').replaceWith(errorMessagesSpan);
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
      dialogContainer.prepend('<div id="flash"></div>');

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