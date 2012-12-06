# Could also be called CurrentUser

Clockwork.Session = Ember.Object.extend
  init: ->
    session = this
    $.getJSON '/session', (data, status) ->
      session.setProperties data.session
