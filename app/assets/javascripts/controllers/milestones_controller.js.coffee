Shiftplan.MilestonesController = Ember.ArrayController.extend
  content: []
  newMilestone: ->
    Shiftplan.Milestone.createRecord()
