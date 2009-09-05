$(document).ready(function() {
  // find out which tab to select
  var uri = URI.parse(window.location.href);
  var directory = uri.directory;

  var selected_tab = 0;

  if(directory.search(/^\/workplaces/) > -1) {
    selected_tab = 1;
  } else if(directory.search(/^\/employees/) > -1) {
    selected_tab = 2;
  }

  $('#content').tabs({
    selected: selected_tab
  });
});