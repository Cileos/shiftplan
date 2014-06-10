# = require jquery.svg.js
# = require showdown

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
  motivation: DS.attr 'string'
  instructions: DS.attr 'string'
  examples: DS.attr 'array'

Tut.initializer
  name: 'load_chapters'
  initialize: (container)->
    $('#fixtures').each ->
      Tut.Chapter.FIXTURES = $(this).data('chapters')

Tut.Router.map ->
  @route 'chapter', path: 'chapter/:chapter_id'

Tut.ApplicationRoute = Ember.Route.extend
  actions:
    gotoChapter: (chapter)->
      @transitionTo 'chapter', chapter
    error: (exception)->
      @transitionTo 'index'

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

  didInsertElement: ->
    $map = @$('svg')
    width = $map.attr('width')
    height = $map.attr('height')
    $map.attr 'viewBox', [0,0,width,height].join(' ')


# We replace all occurences of [Visible Title]{#a_css .selector} to %span.hint
# to highlight the element with the corresponding selector in the main document
hintElements = (converter)->
  [
    {
      type: 'lang'
      regex: '\\[([^\\]]+)\\]\\{([^}]+)\\}'
      replace: (match, name, selector)->
        """
        <span class="hint" rel="#{selector}">#{name}</span>
        """
    }
  ]
showdown = new Showdown.converter(extensions: [hintElements])
Ember.Handlebars.helper 'format-markdown-with-element-hints', (value, options)->
  if value?
    new Handlebars.SafeString(showdown.makeHtml(value))
  else
    ''

Tut.ChapterView = Ember.View.extend
  click: (event)->
    ele = $(event.target)
    if ele.is('.hint')
      selector = ele.attr('rel')
      console?.debug "hinting to", selector
      parent.postMessage ["hint", selector], "*"
    false


Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  classNameBindings: [ 'isHovered:hover', 'isMarker:marker', 'isActive:active']
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  isHovered: false
  visit: 'gotoChapter'
  chapterId:
    Ember.computed ->
      @get('elementId').replace(/^tutorial_step_/, '')
    .property('elementId')

  isMarker:
    Ember.computed ->
      if id = @get('elementId')
        id.indexOf('tutorial_step_') is 0
    .property('elementId')

  # assuming there is a 'chapter' route
  isActive:
    Ember.computed ->
      router = @get('router')
      router.isActive 'chapter', @get('chapterId')
    .property('isMarker', 'router.url')

  router:
    Ember.computed ->
      @container.lookup('router:main')
    .property()


  click: (event)->
    @sendAction 'visit', @get('chapterId')

  mouseEnter: (event)->
    @set('isHovered', true)

  mouseLeave: (event)->
    @set('isHovered', false)

window.Tut = Tut
