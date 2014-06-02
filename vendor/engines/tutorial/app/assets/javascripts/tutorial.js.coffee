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

Tut.IndexView = Ember.View.extend
  elementId: 'container'

Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  classNameBindings: [ 'isHovered:hover' ]
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  isHovered: false

  click: (event)->
    console?.info 'tricky click!', $(event.target), @toString()

  mouseEnter: (event)->
    @set('isHovered', true)

  mouseLeave: (event)->
    @set('isHovered', false)

window.Tut = Tut
