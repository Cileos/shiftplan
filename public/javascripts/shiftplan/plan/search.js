$(document).ready(function() {
  $('input#employee_search_query').quicksearch('#employee_search table tbody tr');
  $('input#workplace_search_query').quicksearch('#workplace_search table tbody tr');
  $('input#qualification_search_query').quicksearch('#qualification_search table tbody tr');

  $('#sidebar a.show_search').click(function(event) {
    event.preventDefault();

    var target = this.id.match(/show_(.*)/)[1];
    $('#' + target).show();
  });

  $('.search_box .close').click(function(event) {
    event.preventDefault();

    var search_box = $(this).closest('.search_box');

    // show all selected, hide all unselected
    search_box.find('input[type=checkbox]').each(function() {
      var checkbox = $(this);
      var resource = $('#sidebar .' + checkbox.closest('tr').attr('class'));
      checkbox.is(':checked') ? resource.show() : resource.hide();
    });

    search_box.hide();
  });

  $('.search_box .select_all').click(function(event) {
    event.preventDefault();
    $(this).closest('.search_box').find('input[type=checkbox]').attr('checked', 'checked');
  });

  $('.search_box .deselect_all').click(function(event) {
    event.preventDefault();
    $(this).closest('.search_box').find('input[type=checkbox]').removeAttr('checked');
  });
});
