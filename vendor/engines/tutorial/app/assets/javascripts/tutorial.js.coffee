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
  didInsertElement: ->
    @$().on 'click', 'path', redirectToView('click')
    # ^ does not work with mouse*

Tut.InteractivePathComponent = Ember.Component.extend
  tagName: 'path'
  attributeBindings: Ember.String.w 'type style id cx cy rx ry d transform label'
  didInsertElement: ->
    @$().on 'mouseenter', (e)=> @mouseEnter(e)
    @$().on 'mouseleave', (e)=> @mouseLeave(e)

  click: (event)->
    console?.info 'tricky click!', $(event.target), @toString()

  mouseEnter: (event)->
    console?.info 'tricky mouseEnter!', $(event.target), @toString()

  mouseLeave: (event)->
    console?.info 'tricky mouseLeave!', $(event.target), @toString()

window.Tut = Tut
