Clockwork.DayInCalendar = Ember.Object.extend
  date: null
  dayInWeek: (->
    @get('date').day()
  ).property('date')
  dayInMonth: (->
    @get('date').date()
  ).property('date')


Clockwork.UnavailabilitiesController = Ember.ArrayController.extend
  year: null
  month: null
  locale: 'en'

  # monday is hardcoded as first day of week, because moment.weekdaysShort()
  # always returns sunday first.
  weekdayNames: (->
    moment("1997-08-#{11+day}").format('dd') for day in [0..6]
  ).property()

  content: (->
    @store.findQuery('unavailability', year: @get('year'), month: @get('month'))
  ).property('year', 'month')

  days: (->
    year = @get('year')
    month = @get('month')
    return [] unless year?
    return [] unless month?
    days = []
    d = moment "#{year}-#{month}-01"
    while d.month() is month - 1
      day = Clockwork.DayInCalendar.create date: d
      days.pushObject(day)
      d = d.clone().add('days', 1)

    days
  ).property('year', 'month')

  # TODO hide row header in table
  weeks: (->
    [1,2,3,4,5,6]
  ).property('year', 'month')

  daysGroupedByWeek: ( ->
    weeks = [[]]
    days = @get('days')
    return weeks if days.length == 0
    index = -7
    firstWeekDay = days[0].get('dayInWeek') - 1
    for i in [1..firstWeekDay]
      weeks[0].push "fnord"
    for i in [firstWeekDay..6]
      index += 1
      weeks[0].push days[i-firstWeekDay]
    while ((index += 7) < days.length)
      weeks.push(days.slice(index, index+7))

    weeks

  ).property('days')

