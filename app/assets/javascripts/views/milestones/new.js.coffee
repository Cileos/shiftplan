Shiftplan.NewMilestoneView = Ember.TextField.extend
  insertNewline: (event) ->
    value = @get('value')

    if value
      milestone = Shiftplan.Milestone.createRecord name: value
      Shiftplan.store.commit()
      @get('parentView').hideNew()
