Clockwork.MilestonesController = Ember.ArrayController.extend
  needs: ['employees']
  init: ->
    @_super()
    # must fetch ALL the records so they appear in the list
    Clockwork.Milestone.find()

  can_manage: Clockwork.isOwnerOrPlanner()
