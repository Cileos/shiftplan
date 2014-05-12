Clockwork.UnavailabilitiesItemInListView = Ember.View.extend
  templateName: 'unavailabilities/item_in_list'
  click: (e)->
    @get('controller').transitionToRoute 'unavailabilities.edit', @get('content')

Clockwork.MonthlyCalendarView = GroupingTable.createView
  columnProperty: 'dayInWeek'
  rowProperty: 'weekInYear'
  columnHeaderProperty: 'humanDayInWeek'
  cellLabelView: Ember.View.extend
    tagName: 'span'
    templateName: 'unavailabilities/day_in_month'

  cellListItemView: Clockwork.UnavailabilitiesItemInListView
  elementId: 'calendar'
  classNames: ['calendar']

  click: (e)->
    if $(e.target).is('td')
      $(e.target).find('a.day-in-month').click()
