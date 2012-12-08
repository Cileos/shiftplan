// make the whole td.checkbox react on click()
$(document).ready(function() {
  $('td.checkbox input').click(function(e){
    e.stopPropagation();
  });

  $('td.checkbox').click(function(){
    $(this).find('input').click();
  });
});
