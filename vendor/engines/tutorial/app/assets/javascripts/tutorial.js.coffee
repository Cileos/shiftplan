# = require jquery.svg.js

unless $.svg?.isSVGElem
  $.svg ||= {}
  svgNS = "http://www.w3.org/2000/svg"
  $.svg.isSVGElem = (node)->
    node.nodeType is 1 and node.namespaceURI is svgNS

Tut = Ember.Application.create
  LOG_TRANSITIONS: true

Tut.ApplicationAdapter = DS.FixtureAdapter

Tut.Chapter = DS.Model.extend
  title: DS.attr 'string'

Tut.Chapter.FIXTURES = [
  { id: 'email', title: 'Erstanmeldung mit Email' }
  { id: 'account', title: 'Der Account' }
]

Tut.Router.map ->
  @route 'chapter', path: 'chapter/:chapter_id'

Tut.ApplicationRoute = Ember.Route.extend
  actions:
    gotoChapter: (chapter)->
      @transitionTo 'chapter', chapter

Tut.ChapterRoute = Ember.Route.extend
  activate: ->
    @_super()
    @controllerFor('application').set('isOpened', true)
  deactivate: ->
    @_super()
    @controllerFor('application').set('isOpened', false)



Tut.ApplicationController = Ember.Controller.extend
  isOpened: false # set by routes

Tut.ApplicationView = Ember.View.extend
  elementId: 'tutorial'
  classNameBindings: ['isOpened']
  isOpenedBinding: 'controller.isOpened'


Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  classNameBindings: [ 'isHovered:hover' ]
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  isHovered: false
  visit: 'gotoChapter'
  chapterId:
    Ember.computed ->
      @get('elementId').replace(/^tutorial_step_/, '')
    .property('elementId')


  click: (event)->
    @sendAction 'visit', @get('chapterId')

  mouseEnter: (event)->
    @set('isHovered', true)

  mouseLeave: (event)->
    @set('isHovered', false)

window.Tut = Tut
