$(document).ready(function() {
  $('li.workplace').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    // find link with class 'clickable_link' and open a dialog for it
    // createDialogForLink($('a.clickable_link', $(this)));
    var match = this.id.match(/workplace_(\d+)/);
    if(match) {
      var id = parseInt(match[1]);
      var path = '/workplaces/' + id;
      var method = 'get';
      $.ajax({
        url: path,
        type: method,
        dataType: 'json'
      });
      $('#workplace_form').attr('target', path)
    } else {
      // formular umbauen
    }
  });
});