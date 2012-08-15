# must set rootElement later because the DOM is not loaded yet
window.Shiftplan = Ember.Application.create
  rootElement: '#ember'

#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require_self

Shiftplan.initialize()

