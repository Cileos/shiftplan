#= require_tree ./setup

Setup = Ember.Application.create
  rootElement: '#setup'
  page: 'setup' # for i18n

load_translations(Setup)

Setup.Setup = Ember.Object.extend()

Setup.Router.map ->
  @resource 'setup', ->
    @route 'user'

Setup.ApplicationView = Ember.View.extend
  templateName: 'setup/application'

Setup.IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo 'setup.user'

Setup.SetupRoute = Ember.Route.extend
  model: ->
    Setup.Setup.create()

Setup.SetupUserRoute = Setup.SetupRoute.extend()

window.Setup = Setup
