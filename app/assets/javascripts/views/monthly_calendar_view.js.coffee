Clockwork.MonthlyCalendarView = GroupingTable.createView
  columnProperty: 'dayInWeek'
  rowProperty: 'weekInYear'
  columnHeaderProperty: 'humanDayInWeek'
  cellLabelView: Ember.View.extend
    tagName: 'span'
    templateName: 'unavailabilities/day_in_month'
  cellListItemView: Ember.View.extend
    templateName: 'unavailabilities/item_in_list'
  elementId: 'calendar'
  classNames: ['calendar']


Clockwork.FnordView = Ember.CollectionView.extend
  init: ->
    window.f = this
    @_super()
  itemViewClassX: Ember.View.extend
    template: Ember.Handlebars.compile 'N{{view.content}}N'
  itemViewClass: Ember.ContainerView.extend
    childViews: ['up', 'down']
    itemsBinding: 'parentView.content'
    up: Ember.View.extend
      number: (->
        @get('parentView.items.length')
      ).property('parentView.items.@each')
      template: Ember.Handlebars.compile 'U{{view.number}}U'
    down: Ember.View.extend
      template: Ember.Handlebars.compile 'D{{view.parentView.content}}/{{view.parentView.parentView.content.length}}D'
