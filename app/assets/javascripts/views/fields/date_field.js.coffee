# {{view Clockwork.Fields.DueDateField rawValueBinding="dueAt" placeholder="Fällig am"}}
Clockwork.Fields.DateField = Ember.TextField.extend
  rawValue: null
  formatBinding: 'Clockwork.settings.dateFormat'
  didInsertElement: ->
    field = this
    @$().rails_datepick
      onSelect: (dates)->
        date = dates[0]
        field.set 'rawValue', date

  value: ( (key, val)->
    if arguments.length > 1 # setter
      date = $.rails_datepick.parse(val)
      @set('rawValue', date)
      date
    else
      $.rails_datepick.format(@get('rawValue'))
  ).property('rawValue')
