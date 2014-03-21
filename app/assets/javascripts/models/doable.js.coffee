Clockwork.Doable = Ember.Mixin.create
  name: DS.attr('string')
  dueAt: DS.attr('date')
  done: DS.attr('boolean')

  description: DS.attr('string')

  formatted_due_on: ( (key,value) ->
    format = Clockwork.get('settings.dateFormat')
    if arguments.length is 1 # getter
      $.datepick.formatDate format, @get('dueAt')
    else
      @set('dueAt', $.datepick.parseDate(format, value))
      return value
  ).property('dueAt', 'Clockwork.settings.dateFormat')

  # automatically saves the model when it's checkbox is ticked
  commitDone: (->
    @save() if @get('isDirty')
  ).observes('done')

  responsible: DS.belongsTo('employee', key: 'responsible_id')
