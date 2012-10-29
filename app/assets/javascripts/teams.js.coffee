jQuery(document).ready ->
  elmMergeButton = $('#merge-button')
  elmMergeButton.prop('disabled', true)
  
  $(':input#team_color').miniColors()

  $('#teams input[type=checkbox]').click ->
    checkedElms = $('input[type=checkbox]:checked').length
    allCheckboxes = $('#teams input[type=checkbox]')
    allCheckedCheckboxes = $('#teams input[type=checkbox]:checked')


    if checkedElms == 2
      allCheckboxes.prop('disabled', true)
      allCheckedCheckboxes.prop('disabled', false)
      elmMergeButton.prop('disabled', false)
    else
      allCheckboxes.prop('disabled', false)
      elmMergeButton.prop('disabled', true)
      
