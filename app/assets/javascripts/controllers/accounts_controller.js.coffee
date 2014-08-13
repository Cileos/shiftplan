Clockwork.AccountsController = Ember.ArrayController.extend
  content:
    Ember.computed ->
      @store.find 'account'
    .property()
