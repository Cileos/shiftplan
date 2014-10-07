Clockwork.Doable = Ember.Mixin.create
  name: DS.attr('string')
  dueAt: DS.attr('moment')
  done: DS.attr('boolean')

  description: DS.attr('string')

  formattedDueOn: Clockwork.formattedDateProperty 'dueAt'

  # automatically saves the model when it's checkbox is ticked
  commitDone: (->
    @save() if @get('isDirty')
  ).observes('done')

  responsible: DS.belongsTo('employee', key: 'responsible_id')
