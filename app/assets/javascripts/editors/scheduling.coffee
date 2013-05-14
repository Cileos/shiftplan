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

    timeoptions =
      show24Hours: true
      showSeconds: false
      spinnerImage: ''
      timeSteps: [1, 15, 0]

    @input('start_time')
      .timeEntry(timeoptions)
      .on 'change', => @fieldChanged()
    @input('end_time')
      .timeEntry(timeoptions)
      .on 'change', => @fieldChanged()

    @input('team_id')
      .on 'change', => @fieldChanged()

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")

  # sync Quickie => fields
  quickieChanged: ->
    if parsed = Quickie.parse @input('quickie').val()
      @input('start_time').val(parsed.verbose_start_time)
      @input('end_time').val(parsed.verbose_end_time)

      # Entering '9-17' should not change the selected team
      if parsed.space_before_team? and parsed.space_before_team.length > 0
        @setTeamByName(parsed.team_name)

  # sync fields => Quickie
  fieldChanged: ->
    quickie = new Quickie()
    quickie.start_time = @input('start_time').val()
    quickie.end_time = @input('end_time').val()
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
