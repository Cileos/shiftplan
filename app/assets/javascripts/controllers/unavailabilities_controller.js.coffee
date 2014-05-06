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
  employee: null
  locale: 'en'

  # monday is hardcoded as first day of week, because moment.weekdaysShort()
  # always returns sunday first.
  weekdays: (->
    for day in [0..6]
      Clockwork.DayInCalendar.create date: moment("1997-08-#{11+day}")
  ).property()

  fnords: [23,42,66,84]

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
    first = moment("#{@get('year')}-#{@get('month')}-01")
    last = first.clone().endOf('month')
    if first.isoWeek() < last.isoWeek()
      Ember.A([first.isoWeek() .. last.isoWeek()])
    else # happy new year!
      butLast = last.clone().subtract('weeks', 1)
      weeks = Ember.A([first.isoWeek() .. butLast.isoWeek()])
      weeks.pushObject(1)
      weeks
  ).property('year', 'month')

  previousMonth: Ember.computed ->
    month = parseInt @get('month')
    if month == 1 then 12 else month - 1
  .property('month', 'year')

  previousYear: Ember.computed ->
    month = parseInt @get('month')
    year  = parseInt @get('year')
    if month == 1 then year - 1 else year
  .property('month', 'year')

  nextMonth: Ember.computed ->
    month = parseInt @get('month')
    if month == 12 then 1 else month + 1
  .property('month', 'year')

  nextYear: Ember.computed ->
    month = parseInt @get('month')
    year  = parseInt @get('year')
    if month == 12 then year + 1 else year
  .property('month', 'year')

  humanMonth: Ember.computed ->
    moment().month( @get('month') - 1 ).format('MMMM')
  .property('month')


Clockwork.UnavailabilitiesIndexController = Clockwork.UnavailabilitiesController.extend()
