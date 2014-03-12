Clockwork.Fields.DateField = Ember.TextField.extend
  rawValue: null
  formatBinding: 'Clockwork.settings.dateFormat'
  didInsertElement: ->
    field = this
    @$().rails_datepick
      onSelect: (dates)->
        date = dates[0]
        field.set 'rawValue', date

  value: Ember.computed ->
    $.datepick.formatDate($.datepick.ISO_8601, @get('rawValue'))
  .property('rawValue')
