# {{view Clockwork.Fields.DueDateField rawValueBinding="dueAt" placeholder="Fällig am"}}
Clockwork.Fields.DateField = Ember.TextField.extend
  didInsertElement: ->
    field = this
    @$().datepick
      onSelect: (dates)->
        date = dates[0]
        field.$().blur() # hint to Ember to pick up its #value
