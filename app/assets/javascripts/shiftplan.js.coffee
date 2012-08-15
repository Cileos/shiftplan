#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes

Shiftplan = Ember.Application.create
  rootElement: $('#ember')

window.Shiftplan = Shiftplan

Shiftplan.initialize()

