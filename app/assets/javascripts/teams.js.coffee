jQuery(document).ready ->

  $(':input#team_color').miniColors()

  $('div#teams').each ->
    $teams = $(this)
    $elmMergeButton = $('#merge-button')

    $elmMergeButton.click ->
      event.preventDefault()
      $.ajax
        url: $(this).data('url')
        data:
          team_merge:
            team_id: $('input[type=checkbox]:checked').first().data('team-id')
            other_team_id: $('input[type=checkbox]:checked').last().data('team-id')

    refreshBehaviourOfTeamMerge = ->
      disableMergeButton()

      allCheckboxes = $teams.find('input[type=checkbox]')
      allCheckboxes.click ->
        allCheckedCheckboxes = $teams.find('input[type=checkbox]:checked')
        checkedElms = allCheckedCheckboxes.length
        if checkedElms == 2
          allCheckboxes.prop('disabled', true)
          allCheckedCheckboxes.prop('disabled', false)
          enableMergeButton()
        else
          allCheckboxes.prop('disabled', false)
          disableMergeButton()

    disableMergeButton = ->
      $elmMergeButton.prop('disabled', true)
      $elmMergeButton.click -> false

    enableMergeButton = ->
      $elmMergeButton.prop('disabled', false)

    $teams.each refreshBehaviourOfTeamMerge
    $teams.on('update', refreshBehaviourOfTeamMerge)
