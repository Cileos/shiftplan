$(document).ready(function() {
  // find out which tab to select
  var uri = URI.parse(window.location.href);
  var directory = uri.directory;

  var selected_tab = 0;
  var hash = document.location.hash;

  if(hash.search(/^#workplaces$/i) > -1) {
    selected_tab = 1;
  } else if(hash.search(/^#employees$/i) > -1) {
    selected_tab = 2;
  } else if(hash.search(/^#plans$/i) > - 1) {
    selected_tab = 3;
  }

  $('#content').tabs({
    selected: selected_tab,
    idPrefix: 'tab-',
    select: function(event, ui) {
      document.location = '#' + ($(ui.tab).attr('data-tab-id'));
    }
  });
});