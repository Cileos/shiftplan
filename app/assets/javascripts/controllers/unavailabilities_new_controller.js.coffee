Clockwork.UnavailabilitiesNewController = Ember.ObjectController.extend
  canManage: true
  needs: ['accounts']
  accounts: Ember.computed.alias 'controllers.accounts'
  multipleAccounts: Ember.computed ->
    @get('accounts.length') > 1
  .property('accounts.length')

  selectedAccounts: Ember.computed ->
    @get('accounts').filterProperty('selected', true)
  .property('accounts.@each.selected')

  selectedAccountsChanged: (->
    una = @get('content')
    una.set 'accountIds', @get('selectedAccounts').mapProperty('id')
  ).observes('selectedAccounts.@each')
