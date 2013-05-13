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

    @syncedFields = ['start_time', 'end_time']
    for field in @syncedFields
      @input(field).on 'change', => @fieldChanged()
    @input('team_id').on 'change', => @fieldChanged()

    timeoptions =
      show24Hours: true
      showSeconds: false

    @input('start_time').timeEntry(timeoptions)
    @input('end_time').timeEntry(timeoptions)

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")

  # sync Quickie => fields
  quickieChanged: ->
    if parsed = Quickie.parse @input('quickie').val()
      for field in @syncedFields
        @input(field).val(parsed[field])

      # Entering '9-17' should not change the selected team
      if parsed.space_before_team? and parsed.space_before_team.length > 0
        @setTeamByName(parsed.team_name)

  # sync fields => Quickie
  fieldChanged: ->
    quickie = new Quickie()
    for field in @syncedFields
      quickie[field] = @input(field).val()
    teamField = @input('team_id')
    quickie.team_name = teamField.find("option[value=#{teamField.val()}]").text()

    @input('quickie').val(quickie.toString())

  setTeamByName: (name) ->
    input = @input('team_id')

    unless name?
      input.val( '' ) # prompt
      return

    name = name.replace(/"/, '\\"') # escape quotes so the CSS selector won't break
    if found = input.find("option:contains(\"#{name}\")")
      value = found.attr('value')
      text  = found.text()
      if text is name
        input.val( value )
      else
        input.val( '' ) # prompt
    else
      input.val( '' ) # prompt
