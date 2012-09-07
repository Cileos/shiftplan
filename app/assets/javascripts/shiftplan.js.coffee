#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes

Shiftplan = Ember.Application.create
  rootElement: 'body#ember'
  Fields: Ember.Object.extend()

Shiftplan.store = DS.Store.create
  revision: 4
  adapter: DS.RESTAdapter.create
    bulkCommit: false
    #plurals:
    #  directory: 'directories'

Shiftplan.settings = Ember.Object.create
  dateFormat: 'yy-mm-dd' # TODO globalize

window.Shiftplan = Shiftplan

jQuery ->
  if $('body#ember').length > 0
    # base all URLs on current plan
    Shiftplan.store.get('adapter').set 'namespace', (window.location.pathname.replace(/(plans\/\d+).*$/,'$1')).slice(1)
    Shiftplan.initialize()
