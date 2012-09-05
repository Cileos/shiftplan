#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes

Shiftplan = Ember.Application.create
  rootElement: '#ember'

Shiftplan.store = DS.Store.create
  revision: 4
  adapter: DS.RESTAdapter.create
    bulkCommit: false
    #plurals:
    #  directory: 'directories'

window.Shiftplan = Shiftplan

jQuery ->
  # base all URLs on current plan
  Shiftplan.store.get('adapter').set 'namespace', (window.location.pathname.replace(/(plans\/\d+).*$/,'$1')).slice(1)
  Shiftplan.initialize()
