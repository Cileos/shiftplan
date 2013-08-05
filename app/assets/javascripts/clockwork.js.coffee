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
  autoinit: false
  rootElement: '#milestones'
  Fields: Ember.Object.extend()

Clockwork.store = DS.Store.create
  revision: 7
  adapter: DS.RESTAdapter.create
    bulkCommit: false
    mappings:
      responsibles: 'Clockwork.Employee'
    #plurals:
    #  directory: 'directories'

Clockwork.settings = Ember.Object.create
  dateFormat: 'yy-mm-dd' # TODO globalize

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
    Clockwork.store.get('adapter').set 'namespace', (window.location.pathname.replace(/(plans\/[^/]+).*$/,'$1')).slice(1)
    Clockwork.set 'employees', Clockwork.Employee.find()
    Clockwork.set 'current_user', Ember.Object.create(role: $root.data('role'))
    Clockwork.initialize()
