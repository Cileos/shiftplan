Clockwork.FlashMessageView = Ember.View.extend
  severity: (->
    "alert-#{@get('content.severity')}"
  ).property('content.severity')
  template: Ember.Handlebars.compile """
  <div {{bindAttr class=":flash :alert view.severity"}}>{{view.content.message}}</div>
  """

Clockwork.FlashMessagesView = Ember.Rails.FlashListView.extend
  classNames: 'flash'.w()
  itemViewClass: Clockwork.FlashMessageView
