Clockwork.UnavailabilitiesNewController = Ember.ObjectController.extend
  canManage: true
  needs: ['accounts']
  availableAccounts: Ember.computed.alias 'controllers.accounts'
  multipleAccounts: Ember.computed ->
    @get('availableAccounts.length') > 1
  .property('availableAccounts.length')

  accountSelectorVisible:
    Ember.computed ->
      @get('multipleAccounts') and !@get('content.employee') and !@get('content.id')
    .property('multipleAccounts', 'content.employee')
