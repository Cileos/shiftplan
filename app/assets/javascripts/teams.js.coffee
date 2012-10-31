jQuery(document).ready ->
  elmMergeButton = $('#merge-button')
  elmMergeButton.prop('disabled', true)
  elmMergeButton.click -> false

  $(':input#team_color').miniColors()

  $('#teams input[type=checkbox]').live 'click', (event)  ->
    checkedElms = $('input[type=checkbox]:checked').length
    allCheckboxes = $('#teams input[type=checkbox]')
    allCheckedCheckboxes = $('#teams input[type=checkbox]:checked')


    if checkedElms == 2
      allCheckboxes.prop('disabled', true)
      allCheckedCheckboxes.prop('disabled', false)

      elmMergeButton.prop('disabled', false)
      elmMergeButton.click ->
        event.preventDefault()
        $.ajax
          url: $(this).data('url')
          data:
            team_merge:
              team_id: $('input[type=checkbox]:checked').first().data('team-id')
              other_team_id: $('input[type=checkbox]:checked').last().data('team-id')

    else
      allCheckboxes.prop('disabled', false)

      elmMergeButton.prop('disabled', true)
      elmMergeButton.click -> false

