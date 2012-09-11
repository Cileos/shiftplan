Shiftplan.Fields.DateField = Ember.TextField.extend
  formatBinding: 'Shiftplan.settings.dateFormat'
  didInsertElement: ->
    @$().datepicker
      dateFormat: @get('format')
