Clockwork.Fields.SelectEmployee = Ember.Select.extend
  attributeBindings: 'name'.w()
  contentBinding: 'Clockwork.employees'
  optionValuePath: 'content.id'
  optionLabelPath: 'content.name'
  prompt: '-- Mitarbeiter --'
