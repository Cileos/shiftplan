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

Clockwork.initializer
  # injects 'currentUser' in every controller for authorization
  name: 'currentUser'
  initialize: (container) ->
    Clockwork.deferReadiness()
    $ ->
      $root = $(Clockwork.rootElement)
      user = Ember.Object.create
        role: $root.data('role')

      controller = container.lookup('controller:currentUser').set('content', user)
      container.typeInjection('controller', 'currentUser', 'controller:currentUser')
      Clockwork.advanceReadiness()

Clockwork.ApplicationSerializer = DS.ActiveModelSerializer.extend()

window.Clockwork = Clockwork

jQuery ->
  if ($root = $('#milestones')).length > 0
    # base all URLs on current plan
    Clockwork.ApplicationAdapter = DS.RESTAdapter.extend
      namespace: (window.location.pathname.replace(/(plans\/[^/]+).*$/,'$1')).slice(1)
    Clockwork.advanceReadiness()
