$(document).ready(function() {
  $('li.clickable').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    // find link with class 'clickable_link' and open a dialog for it
    createDialogForLink($('a.clickable_link', $(this)));
  });
});