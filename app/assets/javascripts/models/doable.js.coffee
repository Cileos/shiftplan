Clockwork.Doable = Ember.Mixin.create
  name: DS.attr('string')
  due_at: DS.attr('date')
  done: DS.attr('boolean')

  description: DS.attr('string')

  formatted_due_on: ( (key,value) ->
    format = Clockwork.get('settings.dateFormat')
    if arguments.length is 1 # getter
      $.datepick.formatDate format, @get('due_at')
    else
      @set('due_at', $.datepick.parseDate(format, value))
      return value
  ).property('due_at', 'Clockwork.settings.dateFormat')

  responsible: DS.belongsTo('employee', key: 'responsible_id')
