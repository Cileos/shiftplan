Shiftplan.NewMilestoneView = Ember.TextField.extend
  attributeBindings: ['name']
  name: 'Name' # TODO i18n
  insertNewline: (event) ->
    value = @get('value')
    if value
      @get('parentView').get('controller').createMilestone(value)
      @get('parentView').hideNew()
