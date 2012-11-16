Clockwork.Fields.DateField = Ember.TextField.extend
  formatBinding: 'Clockwork.settings.dateFormat'
  didInsertElement: ->
    @$().datepicker
      dateFormat: @get('format')
