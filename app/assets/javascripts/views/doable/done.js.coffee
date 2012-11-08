Shiftplan.DoableDoneView = Ember.Checkbox.extend
  attributeBindings: ['name', 'disabled']
  name: 'done'

  # try to keep race conditions caused by double-clicks to a minimum
  disabled: (->
    if @get('content.isSaving')
      'disabled'
    else
      ''
  ).property('content.isSaving')


