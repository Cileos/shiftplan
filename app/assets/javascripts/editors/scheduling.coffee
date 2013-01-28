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
      .keyup => @quickieChanged()

  input: (name) ->
    @get('element').find(":input[name=\"scheduling[#{name}]\"]")


  quickieChanged: (event) ->
    if parsed = Quickie.parse @input('quickie').val()
      console.debug "the quickie changed to", parsed
      @input('start_hour').val(parsed.start_hour)
      @input('end_hour').val(parsed.end_hour)
    else
      console.debug "unparsable quickie :("


