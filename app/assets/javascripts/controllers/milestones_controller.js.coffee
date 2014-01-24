Clockwork.MilestonesController = Ember.ArrayController.extend
  #needs: ['employees']
  can_manage: Clockwork.isOwnerOrPlanner()
