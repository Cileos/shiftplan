# = require lib/load_fixtures_from_dom
# = require_tree ./setup

Setup = Ember.Application.create
  rootElement: '#setup'
  page: 'setup' # for i18n
  steps: [
    'user',
    'account',
    'organization',
    'complete'
  ]

Setup.ChapterAdapter = DS.FixtureAdapter

load_translations(Setup)

Setup.Setup = DS.Model.extend
  employeeFirstName: DS.attr('string')
  employeeLastName: DS.attr('string')
  accountName: DS.attr('string')
  organizationName: DS.attr('string')
  teamNames: DS.attr('string')

Setup.Chapter = DS.Model.extend
  title: DS.attr 'string'
  motivation: DS.attr 'string'
  instructions: DS.attr 'string'
  examples: DS.attr 'array'

load_fixtures_from_dom(Setup, 'Chapter', 'chapters')

Setup.Router.map ->
  @resource 'setup', ->
    @route 'step', path: ':step'

Setup.ApplicationView = Ember.View.extend
  templateName: 'setup/application'
Setup.SetupView = Ember.View.extend
  templateName: 'setup/setup'

Setup.IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo 'setup.step', Setup.get('steps.firstObject')

Setup.SetupRoute = Ember.Route.extend
  model: (params)->
    @store.find 'setup', 'current'
  actions:
    gotoStep: (step)->
      @transitionTo 'setup.step', step

Setup.SetupStepRoute = Ember.Route.extend
  model: (params)->
    params.step

  renderTemplate: ->
    @render 'setup/steps/' + @modelFor('setup_step'),
      into: 'setup'
      outlet: 'step'
      controller: 'setup'


Setup.ApplicationController = Ember.Controller.extend()

Setup.SetupController = Ember.ObjectController.extend
  needs: ['setup_step']
  stepBinding: 'controllers.setup_step.content'
  stepsBinding: 'Setup.steps'
  stepPosition:
    Ember.computed ->
      curr = @get('step')
      return 0 unless curr?
      steps = @get('steps')
      steps.indexOf(curr)
    .property('step')
  nextStep:
    Ember.computed ->
      steps = @get('steps')
      pos = @get('stepPosition')

      steps[pos + 1] || steps[ steps.length - 1]
    .property('stepPosition')
  previousStep:
    Ember.computed ->
      steps = @get('steps')
      pos = @get('stepPosition')

      if pos < 0
        steps[0]
      else
        steps[pos-1]
    .property('stepPosition')
  hasPrevious:
    Ember.computed ->
      @get('stepPosition') > 0
    .property('stepPosition')
  hasNext:
    Ember.computed ->
      @get('stepPosition') < @get('steps.length') - 1
    .property('stepPosition')

  chapter:
    Ember.computed ->
      curr = @get('step')
      return unless curr?
      @store.find 'chapter', curr
    .property('step')

Setup.SetupStepController = Ember.ObjectController.extend()

window.Setup = Setup
