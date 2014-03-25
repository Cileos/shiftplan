Clockwork.MonthlyCalendarView = GroupingTable.extend
  columnProperty: 'dayInWeek'
  rowProperty: 'weekInYear'
  columnHeaderProperty: 'humanDayInWeek'
  cellView: Ember.View.extend
    tagName: 'span'
    templateName: 'unavailabilities/day_in_month'
  elementId: 'calendar'
