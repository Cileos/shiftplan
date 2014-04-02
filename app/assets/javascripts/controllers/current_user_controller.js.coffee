# FIXME: cheap way of re-implementing abilities.
#
# If we do not want to send a Request for each resource  to the server, we
# have to re-implement something like cancan.
Clockwork.CurrentUserController = Ember.ObjectController.extend
  isOwnerOrPlanner: Ember.computed ->
    role = @get('role')
    role is 'owner' or role is 'planner'
  .property('role')

  canManageBinding: 'isOwnerOrPlanner'
