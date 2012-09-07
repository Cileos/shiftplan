Shiftplan.Milestone = DS.Model.extend
  name: DS.attr('string')
  due_at: DS.attr('date')

  formatted_due_on: (->
    $.datepicker.formatDate Shiftplan.get('settings.dateFormat'), @get('due_at')
  ).property('due_at', 'Shiftplan.settings.dateFormat')
