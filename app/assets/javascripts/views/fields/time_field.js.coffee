Clockwork.Fields.TimeField = Ember.TextField.extend
  didInsertElement: ->
    @$().timeEntry(Clockwork.settings.get('timeoptions'))
