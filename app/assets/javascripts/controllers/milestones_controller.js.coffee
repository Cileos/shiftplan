Shiftplan.MilestonesController = Ember.ArrayController.extend
  content: []
  createMilestone: (name, due_at) ->
    milestone = Shiftplan.Milestone.createRecord name: name, due_at: due_at
    Shiftplan.store.commit()
