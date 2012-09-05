Shiftplan.MilestonesController = Ember.ArrayController.extend
  content: []
  createMilestone: (name) ->
    milestone = Shiftplan.Milestone.createRecord name: name
    Shiftplan.store.commit()
