# = require jquery.svg.js

unless $.svg?.isSVGElem
  $.svg ||= {}
  svgNS = "http://www.w3.org/2000/svg"
  $.svg.isSVGElem = (node)->
    node.nodeType is 1 and node.namespaceURI is svgNS

Tut = Ember.Application.create
  LOG_TRANSITIONS: true

Tut.ApplicationView = Ember.View.extend
  elementId: 'tutorial'

redirectToView = (eventName)->
  (event) ->
    id = $(event.target).attr('id')
    if id?
      view = Ember.View.views[id]
      if view? and view[eventName]
        view[eventName](event)

Tut.IndexView = Ember.View.extend
  elementId: 'container'
  didInsertElement: ->
    @$().on 'click', 'path', redirectToView('click')
    # ^ does not work with mouse*

Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  classNameBindings: [ 'isHovered:hover' ]
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  isHovered: false
  didInsertElement: ->
    @$().on 'mouseenter', (e)=> @mouseEnter(e)
    @$().on 'mouseleave', (e)=> @mouseLeave(e)

  click: (event)->
    console?.info 'tricky click!', $(event.target), @toString()

  mouseEnter: (event)->
    @set('isHovered', true)
    console?.info 'tricky mouseEnter!', $(event.target), @toString()

  mouseLeave: (event)->
    @set('isHovered', false)
    console?.info 'tricky mouseLeave!', $(event.target), @toString()

window.Tut = Tut
