Clockwork.UnavailabilitiesNewController = Ember.ObjectController.extend
  canManage: true
  needs: ['accounts']
  accounts: Ember.computed.alias 'controllers.accounts'
  multipleAccounts: Ember.computed ->
    @get('accounts.length') > 1
  .property('accounts.length')
