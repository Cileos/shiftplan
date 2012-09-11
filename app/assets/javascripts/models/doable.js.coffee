Shiftplan.Doable = Ember.Mixin.create
  name: DS.attr('string')
  due_at: DS.attr('date')
  done: DS.attr('boolean')

  formatted_due_on: ( (key,value) ->
    format = Shiftplan.get('settings.dateFormat')
    if arguments.length is 1 # getter
      $.datepicker.formatDate format, @get('due_at')
    else
      @set('due_at', $.datepicker.parseDate(format, value))
      return value
  ).property('due_at', 'Shiftplan.settings.dateFormat')
