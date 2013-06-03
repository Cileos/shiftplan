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
      .on('change autocompleteclose blur', => @updateFields())
      .on('blur', => @updateQuickie())
      .bindWithDelay('keyup', (=> @updateFields()), 150)
      .closest('form').on('submit', => @updateQuickie()).end()

    timeoptions =
      show24Hours: true
      showSeconds: false
      spinnerImage: ''
      timeSteps: [1, 15, 0]
      useMouseWheel: true

    # holds the state, there should be only ONE here
    @quickie = new Quickie()

    @input('start_time')
      .timeEntry(timeoptions)
      .bindWithDelay('keyup mousewheel', (=> @updateQuickie()), 150)
    @input('end_time')
      .timeEntry(timeoptions)
      .bindWithDelay('keyup mousewheel', (=> @updateQuickie()), 150)

    @input('team_id')
      .bindWithDelay('change', (=> @updateQuickie()), 150)

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")

  updateFields: ->
    @quickie.parse( @input('quickie').val() )
    if @quickie.isValid()
      @input('start_time').timeEntry('setTime', @quickie.verbose_start_time)
      @input('end_time').timeEntry('setTime', @quickie.verbose_end_time)

      # Entering '9-17' should not change the selected team
      if @quickie.space_before_team? and @quickie.space_before_team.length > 0
        @setTeamByName(@quickie.team_name)
    else
      @input('start_time').val('')
      @input('end_time').val('')


  recalculateQuickie: ->
    previousTeamName = @quickie.team_name
    previousTeamShortcut = @quickie.team_shortcut
    @quickie.clear()
    @quickie.start_time = @input('start_time').val()
    @quickie.end_time = @input('end_time').val()
    teamField = @input('team_id')
    if teamField.val().length > 0
      selected = teamField.find("option[value=#{teamField.val()}]")
      if selected.length > 0
        @quickie.team_name = selected.text()
    # do not clear name of not-yet existing Team
    @quickie.team_name = previousTeamName if !@quickie.team_name? or @quickie.team_name.length == 0
    @quickie.team_shortcut = previousTeamShortcut if !@quickie.team_shortcut? or @quickie.team_shortcut.length == 0

  updateQuickie: ->
    @recalculateQuickie()
    if @quickie.isValid()
      @input('quickie').val(@quickie.toString())

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
