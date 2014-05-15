Tut = Ember.Application.create
  LOG_TRANSITIONS: true

Tut.ApplicationView = Ember.View.extend
  elementId: 'tutorial'

Tut.IndexView = Ember.View.extend
  didInsertElement: ->
    @$().on 'click', 'path', (e) => @clickedPath(e)

  clickedPath: (event)->
    console?.info 'manual click!', $(event.target), @

Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'

window.Tut = Tut
