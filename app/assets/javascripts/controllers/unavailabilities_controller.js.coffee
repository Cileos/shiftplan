Clockwork.DayInCalendar = Ember.Object.extend
  date: null
  dayInWeek: (->    # 0-6 0==Sunday
    @get('date').day()
  ).property('date')
  dayInMonth: (->    # 1-31/30/28/29
    @get('date').date()
  ).property('date')
  weekInYear: (->  # 1-~52, respecting Jan 4th
    @get('date').isoWeek()
  ).property('date')
  humanDayInWeek: (->
    @get('date').format('dd')
  ).property('date')


Clockwork.UnavailabilitiesController = Ember.ArrayController.extend
  year: null
  month: null
  locale: 'en'

  # monday is hardcoded as first day of week, because moment.weekdaysShort()
  # always returns sunday first.
  weekdays: (->
    for day in [0..6]
      Clockwork.DayInCalendar.create date: moment("1997-08-#{11+day}")
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

  # TODO show only weeks in #year/month
  weeks: (->
    [45..60]
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

