# Attributes:
#   element: the jQuery element of a form used to edit a Scheduling
#
Clockwork.SchedulingEditor = Ember.Object.extend
  init: ->
    @_super()
    @input('quickie')
      .filter(':not(.autocomplete)')
        .edit_quickie()
      .end()
      .on('change autocompleteclose', => @quickieChanged())
      .bindWithDelay('keyup', (=> @quickieChanged()), 150)

    for field in ['start_hour', 'end_hour', 'team_id']
      @input(field).on 'change', => @fieldChanged()

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")


  # sync Quickie => fields
  quickieChanged: ->
    if parsed = Quickie.parse @input('quickie').val()
      @input('start_hour').val(parsed.start_hour)
      @input('end_hour').val(parsed.end_hour)

      # Entering '9-17' should not change the selected team
      if parsed.space_before_team? and parsed.space_before_team.length > 0
        @setTeamByName(parsed.team_name)

  # sync fields => Quickie
  fieldChanged: ->
    quickie = new Quickie()
    quickie.start_hour = @input('start_hour').val()
    quickie.end_hour = @input('end_hour').val()
    teamField = @input('team_id')
    quickie.team_name = teamField.find("option[value=#{teamField.val()}]").text()

    @input('quickie').val(quickie.toString())

  setTeamByName: (name) ->
    input = @input('team_id')

    unless name?
      input.val( '' ) # prompt
      return

    name = name.replace(/"/, '\\"') # escape quotes so the CSS selector won't break
    if found = input.find("option:contains(\"#{name}\")").attr('value')
      input.val( found )
    else
      input.val( '' ) # prompt