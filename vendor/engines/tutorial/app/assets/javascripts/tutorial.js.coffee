Tut = Ember.Application.create
  LOG_TRANSITIONS: true

Tut.ApplicationView = Ember.View.extend
  elementId: 'tutorial'

Tut.IndexView = Ember.View.extend()

Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  click: (event)->
    console?.info "clicked", $(event.target)
  mouseEnter: (event)->
    console?.info "entered", $(event.target)

window.Tut = Tut
