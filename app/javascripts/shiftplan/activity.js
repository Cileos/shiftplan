$(document).ready(function() {
  $('.activity > a').click(function() {
    $('table', $(this).closest('.activity')).each(function() { $(this).toggle(); });
    return false;
  });
});
