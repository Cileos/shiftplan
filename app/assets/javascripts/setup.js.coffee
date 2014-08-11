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
Setup.StepAdapter = DS.FixtureAdapter
Setup.SetupAdapter = DS.ActiveModelAdapter
Setup.ApplicationSerializer = DS.ActiveModelSerializer

load_translations(Setup)

Setup.Setup = DS.Model.extend
  employeeFirstName: DS.attr('string')
  employeeLastName: DS.attr('string')
  accountName: DS.attr('string')
  organizationName: DS.attr('string')
  teamNames: DS.attr('string')

  execute: DS.attr('boolean')
  redirectTo: DS.attr('string')

  isComplete: true

Setup.Chapter = DS.Model.extend
  title: DS.attr 'string'
  motivation: DS.attr 'string'
  instructions: DS.attr 'string'
  examples: DS.attr 'array'

Setup.Step = DS.Model.extend
  position: DS.attr('number')
  successor:
    Ember.computed ->
      @store.find('step', position: @get('position') + 1)
    .property('position')
  hasSuccessor:
    Ember.computed ->
      @get('position') < 1 + @store.findAll('step').get('length')
    .property('position')
  predecessor:
    Ember.computed ->
      @store.find('step', position: @get('position') - 1)
    .property('position')
  hasPredecessor:
    Ember.computed ->
      0 < @get('position')
    .property('position')
  chapter:
    Ember.computed ->
      @store.find 'chapter', @get('id')
    .property('id')

Setup.Step.FIXTURES = Setup.get('steps').map (id, index)->
  { id: id, position: index }
load_fixtures_from_dom(Setup, 'Chapter', 'chapters')

Setup.Router.map ->
  @resource 'setup', ->
    @route 'step', path: ':step_id'

Setup.ApplicationView = Ember.View.extend
  templateName: 'setup/application'
Setup.SetupView = Ember.View.extend
  templateName: 'setup/setup'

Setup.ProgressView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['progress']
  itemViewClass: Ember.View.extend
    templateName: 'setup/progress_item'
    classNameBindings: ['step', 'doneRecently']
    currentStepPositionBinding: 'controller.stepPosition'
    doneRecently:
      Ember.computed ->
        console?.debug "step: " + @get('currentStepPosition')
        "tihihi"
      .property('currentStepPosition')

Setup.IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo 'setup.step', 'user'

Setup.SetupRoute = Ember.Route.extend
  model: (params)->
    window.s = @store.find 'setup', 'singleton'
  actions:
    gotoStep: (step)->
      setup = @modelFor('setup')
      setup.get('errors').clear()
      setup.save().then(
        =>
          @transitionTo 'setup.step', step.id
        ,
        ->
          jQuery('.road').effect('shake', {times: 2}, 111)
          console?.debug "trouble saving"
      )

    finishSetup: ->
      setup = @modelFor('setup')
      setup.set 'execute', true
      setup.get('errors').clear()
      setup.save().then(
        (done)->
          # HACK use a field on Setup model to store redirect location. We
          # cannot send a 30x from the server because jQuery.ajax with
          # transparently use it and repeat the PUT to the new location.
          redirect = done.get('redirectTo')
          if redirect?
            window.location = redirect
        ,
        (req)->
          # something went wrong
          setup.set 'execute', true
      )



Setup.SetupStepRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'setup/steps/' + @modelFor('setup_step').get('id'),
      into: 'setup'
      outlet: 'step'
      controller: 'setup'


Setup.ApplicationController = Ember.Controller.extend()

Setup.SetupController = Ember.ObjectController.extend
  needs: ['setup_step']
  stepBinding: 'controllers.setup_step.content'

Setup.SetupStepController = Ember.ObjectController.extend()

window.Setup = Setup
