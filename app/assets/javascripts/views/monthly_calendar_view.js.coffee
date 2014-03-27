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
