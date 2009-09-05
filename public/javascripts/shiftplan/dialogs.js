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
      }
    });
  });
});