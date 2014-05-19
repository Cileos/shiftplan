Clockwork.ModalFormView = Ember.View.extend Clockwork.ModalMixin, Ember.I18n.TranslateableProperties,
  tagName: 'form'
  content: Ember.computed.alias 'controller.content'

  buttonLabel: Ember.computed ->
    if @get('content.isNew')
      Em.I18n.t 'helpers.actions.create'
    else
      Em.I18n.t 'helpers.actions.update'
  .property('content.isNew')

