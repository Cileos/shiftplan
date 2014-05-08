Clockwork.MilestonesController = Ember.ArrayController.extend
  filteredContent: Ember.computed( ->
    @get('content').filterProperty('isNew', false)
  ).property('content.@each.isNew')
  canManageBinding: 'currentUser.canManageMilestones'
