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
      .on('keyup change autocompleteclose', => @quickieChanged())

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")


  quickieChanged: (event) ->
    if parsed = Quickie.parse @input('quickie').val()
      @input('start_hour').val(parsed.start_hour)
      @input('end_hour').val(parsed.end_hour)
      @setTeamByName(parsed.team_name)

  setTeamByName: (name) ->
    input = @input('team_id')
    name = name.replace(/"/, '\\"') # escape quotes so the CSS selector won't break
    if found = input.find("option:contains(\"#{name}\")").attr('value')
      input.val( found )
