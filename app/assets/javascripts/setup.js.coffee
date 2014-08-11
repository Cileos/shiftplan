# = require lib/load_fixtures_from_dom
# = require_tree ./setup

Setup = Ember.Application.create
  rootElement: '#setup'
  page: 'setup' # for i18n

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
  hint: DS.attr 'string'
  title: DS.attr 'string'
  motivation: DS.attr 'string'
  instructions: DS.attr 'string'
  examples: DS.attr 'array'

# a two-way linked list
Setup.Step = Ember.Object.extend
  position: -1
  successor: null
  predecessor: null
  chapter: null
  doneAge: 9001
  setAsCurrent: (d=0)->
    if d <= 0
      successor.setAsCurrent(d-1) if successor = @get('successor')
    if d >= 0
      predecessor.setAsCurrent(d+1) if predecessor = @get('predecessor')
    @set 'doneAge', d

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
    classNameBindings: ['step', 'doneAge', 'content.id']
    currentStepPositionBinding: 'controller.stepPosition'
    doneAge:
      Ember.computed ->
        age = @get('content.doneAge')
        if age >= 0
          "done-#{age}"
      .property('content.doneAge')

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
  model: (params)->
    @controllerFor('application').get('steps').findBy('id', params.step_id)
  setupController: (controller, model)->
    @_super(controller, model)
    model.setAsCurrent()
  renderTemplate: ->
    @render 'setup/steps/' + @modelFor('setup_step').get('id'),
      into: 'setup'
      outlet: 'step'
      controller: 'setup'


Setup.ApplicationController = Ember.Controller.extend
  stepIds: [
    'user',
    'account',
    'organization',
    'complete'
  ]
  steps:
    Ember.computed ->
      # build linked list
      prev = null

      @get('stepIds').map (id, index)=>
        s = Setup.Step.create
          id: id
          position: index
          predecessor: prev
          chapter: @store.find('chapter', id)

        prev.set 'successor', s if prev?
        prev = s
    .property('stepIds')

Setup.SetupController = Ember.ObjectController.extend
  needs: ['application', 'setup_step']
  stepsBinding: 'controllers.application.steps'
  stepBinding: 'controllers.setup_step.content'

Setup.SetupStepController = Ember.ObjectController.extend()

window.Setup = Setup
