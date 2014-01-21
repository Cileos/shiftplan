Clockwork.Fields.DateField = Ember.TextField.extend
  formatBinding: 'Clockwork.settings.dateFormat'
  didInsertElement: ->
    field = this
    @$().datepick
      onSelect: (dates)->
        date = dates[0]
        field.set 'value', $.datepick.formatDate(field.get('format'), date)

