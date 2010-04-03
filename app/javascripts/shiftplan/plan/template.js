$(document).ready(function() {
  $('form #copy_from_id').change(function() {
    if($(this).val() == '') {
      $('#copy_from_options').hide();
    } else {
      $('#copy_from_options').show();
    }
  });
});
