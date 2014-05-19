#= require ./form
Clockwork.EditDoable = Clockwork.DoableForm.extend
  buttonLabel: Ember.computed ->
    Ember.I18n.t('helpers.actions.update')
