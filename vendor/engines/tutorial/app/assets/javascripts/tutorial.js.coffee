Tut = Ember.Application.create
  LOG_TRANSITIONS: true

Tut.ApplicationView = Ember.View.extend
  elementId: 'tutorial'


window.Tut = Tut
