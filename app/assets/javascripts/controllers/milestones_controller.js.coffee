Clockwork.MilestonesController = Ember.ArrayController.extend
  filteredContent: Ember.computed( ->
    @get('content').filterProperty('isNew', false)
  ).property('content.@each.isNew')
  canManageBinding: 'currentUser.canManageMilestones'


Clockwork.DoableController = Ember.ObjectController.extend
  canManageBinding: 'currentUser.canManageMilestones'

# revisit routes, these names are strange
Clockwork.MilestonesNewController = Clockwork.DoableController.extend()
Clockwork.MilestoneEditController = Clockwork.DoableController.extend()
Clockwork.MilestoneNewTaskController = Clockwork.DoableController.extend()
Clockwork.MilestoneTaskController = Clockwork.DoableController.extend()
