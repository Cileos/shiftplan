Clockwork.Fields.DueDateField = Clockwork.Fields.DateField.extend
  attributeBindings: ['name']
  name: Ember.computed ->
    Ember.I18n.t('activerecord.attributes.milestone.due_at')
  placeholder: Ember.computed ->
    Ember.I18n.t('activerecord.attributes.milestone.due_at')
