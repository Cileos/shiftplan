# = require lib/load_fixtures_from_dom
# = require_tree ./setup

Setup = Ember.Application.create
  rootElement: '#setup'
  page: 'setup' # for i18n
  steps: [
    'user',
    'account',
    'organization',
    'finished'
  ]

Setup.ChapterAdapter = DS.FixtureAdapter

load_translations(Setup)

Setup.Setup = DS.Model.extend
  employee_first_name: DS.attr('string')
  employee_last_name: DS.attr('string')
  account_name: DS.attr('string')
  organization_name: DS.attr('string')
  team_names: DS.attr('string')

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
  beforeModel: -> @transitionTo 'setup', Setup.get('steps.firstObject')

Setup.SetupRoute = Ember.Route.extend
  model: (params)->
    @set 'step', params.step
    @store.find 'setup', 'current'
  setupController: (controller, model)->
    @_super(controller, model)
    controller.set('step', @get('step'))

  renderTemplate: ->
    @render 'setup/setup'
    @render 'setup/steps/' + @get('step'),
      into: 'setup/setup'
      outlet: 'step'
      controller: 'setup'

  actions:
    gotoStep: (step)->
      @transitionTo 'setup', step

Setup.ApplicationController = Ember.Controller.extend()

Setup.SetupController = Ember.ObjectController.extend
  step: null
  nextStep:
    Ember.computed ->
      curr = @get('step')
      steps = Setup.get('steps')
      pos = steps.indexOf(curr)

      steps[pos + 1] || steps[ steps.length - 1]
    .property('step')
  previousStep:
    Ember.computed ->
      curr = @get('step')
      steps = Setup.get('steps')
      pos = steps.indexOf(curr)

      if pos < 0
        steps[0]
      else
        steps[pos-1]
    .property('step')
  chapter:
    Ember.computed ->
      @store.find 'chapter', @get('step')
    .property('step')

window.Setup = Setup
