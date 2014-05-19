Clockwork.Fields.SelectEmployee = Ember.Select.extend
  attributeBindings: 'name'.w()
  contentBinding: 'controller.employees'
  optionValuePath: 'content.id'
  optionLabelPath: 'content.name'
  promptTranslation: 'activerecord.models.employee.one'
  optionGroupPath:
    Ember.computed ->
      if @get('content').mapProperty('account.name').uniq().get('length') > 1
        'account.name'
      else
        null
    .property('content.@each.account.name')
