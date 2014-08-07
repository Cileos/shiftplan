# = require lib/load_fixtures_from_dom
# = require_tree ./setup

Setup = Ember.Application.create
  rootElement: '#setup'
  page: 'setup' # for i18n

Setup.ChapterAdapter = DS.FixtureAdapter

load_translations(Setup)

Setup.Setup = Ember.Object.extend()

Setup.Chapter = DS.Model.extend
  title: DS.attr 'string'
  motivation: DS.attr 'string'
  instructions: DS.attr 'string'
  examples: DS.attr 'array'

load_fixtures_from_dom(Setup, 'Chapter', 'chapters')

Setup.Router.map ->
  @route 'setup', path: 'setup/:step'

Setup.ApplicationView = Ember.View.extend
  templateName: 'setup/application'

Setup.IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo 'setup', 'user'

Setup.SetupRoute = Ember.Route.extend
  beforeModel: (transition)->
    step = transition.params.setup.step
    @set 'step',step
    @controllerFor('application').set('chapter', @store.find( 'chapter', step ) )
  model: (params)->
    Setup.Setup.create()
  renderTemplate: ->
    @render 'setup/' + @get('step')

Setup.ApplicationController = Ember.Controller.extend
  chapter: null

Setup.SetupController = Ember.ObjectController.extend()

window.Setup = Setup
