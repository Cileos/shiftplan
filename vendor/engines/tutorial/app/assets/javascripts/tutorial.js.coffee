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

Tut.Chapter.FIXTURES = [
  { id: 'email', title: 'Erstanmeldung mit Email', motivation: 'Wir wollen Dich kontaktieren können.' }
  { id: 'account', title: 'Der Account', motivation: 'Für den Papierkrams', instructions: "just look at the [menu]{header nav[role=navigation]}" }
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
    false


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
