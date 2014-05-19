Clockwork.DoableForm = Ember.View.extend Clockwork.ModalMixin, Ember.I18n.TranslateableProperties,
  templateName: 'doable/form'
  canManageBinding: 'controller.currentUser.canManageMilestones'

