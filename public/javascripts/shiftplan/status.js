$(document).ready(function() {
  $('.status a.edit, .status a.add').live('click', function(event) {
    var status = $(this).closest('.resource');
    if(status.hasClass('default')) {
      $('.override_only').hide();
      $('.override_only input, .override_only select, .override_only textarea').attr('disabled', 'disabled');
      $('.default_only input, .default_only select, .default_only textarea').removeAttr('disabled');
      $('.default_only').show();
    } else {
      $('.default_only').hide();
      $('.default_only input, .default_only select, .default_only textarea').attr('disabled', 'disabled');
      $('.override_only input, .override_only select, .override_only textarea').removeAttr('disabled');
      $('.override_only').show();
    }
  });
});