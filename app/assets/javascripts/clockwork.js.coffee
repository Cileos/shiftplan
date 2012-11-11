#= require_tree ./ember-patches
#= require_self
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
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
    #plurals:
    #  directory: 'directories'

Clockwork.settings = Ember.Object.create
  dateFormat: 'yy-mm-dd' # TODO globalize

window.Clockwork = Clockwork

jQuery ->
  if $('#milestones').length > 0
    # base all URLs on current plan
    Clockwork.store.get('adapter').set 'namespace', (window.location.pathname.replace(/(plans\/\d+).*$/,'$1')).slice(1)
    Clockwork.initialize()
