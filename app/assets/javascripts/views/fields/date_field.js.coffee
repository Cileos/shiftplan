Shiftplan.Fields.DateField = Ember.TextField.extend
  formatBinding: 'Shiftplan.settings.dateFormat'
  didInsertElement: ->
    @$().datepicker
      dateFormat: @get('format')
  parsedValue: (->
    $.datepicker.parseDate @get('format'), @get('value')
  ).property('value', 'format')
