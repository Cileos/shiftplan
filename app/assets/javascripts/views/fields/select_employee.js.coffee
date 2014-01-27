Clockwork.Fields.SelectEmployee = Ember.Select.extend
  attributeBindings: 'name'.w()
  contentBinding: 'controller.employees'
  optionValuePath: 'content.id'
  optionLabelPath: 'content.name'
  prompt: '-- Mitarbeiter --'
