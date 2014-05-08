Clockwork.DoableForm = Ember.View.extend Clockwork.ModalMixin,
  templateName: 'doable/form'
  buttonLabel: '[buttonLabel]'
  canManageBinding: 'controller.currentUser.canManageMilestones'

