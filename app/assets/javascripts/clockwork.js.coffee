#= require_tree ./ember-patches
#= require_self
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./controllers
#= require ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes

Clockwork = Ember.Application.create
  LOG_TRANSITIONS: true
  rootElement: '#milestones'
  Fields: Ember.Object.extend()

# can be removed when we use Ember everywhere
Clockwork.deferReadiness()

Clockwork.settings = Ember.Object.create
  dateFormat: 'yyyy-mm-dd' # TODO globalize

# FIXME: cheap way of re-implementing abilities.
#
# If we do not want to send a Request for each resource  to the server, we
# have to re-implement something like cancan.
Clockwork.isOwnerOrPlanner = ->
  (->
    role = Clockwork.get('current_user.role')
    role is 'owner' or role is 'planner'
  ).property('Clockwork.current_user.role')


window.Clockwork = Clockwork

jQuery ->
  if ($root = $('#milestones')).length > 0
    # base all URLs on current plan
    Clockwork.ApplicationAdapter = DS.RESTAdapter.extend
      namespace: (window.location.pathname.replace(/(plans\/[^/]+).*$/,'$1')).slice(1)
    Clockwork.set 'current_user', Ember.Object.create(role: $root.data('role'))
    Clockwork.advanceReadiness()
