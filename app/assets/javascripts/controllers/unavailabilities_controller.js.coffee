Clockwork.UnavailabilitiesController = Ember.ArrayController.extend
  year: null
  month: null
  locale: 'en'

  # monday is hardcoded as first day of week, because moment.weekdaysShort()
  # always returns sunday first.
  weekdayNames: (->
    moment("1997-08-#{11+day}").format('dd') for day in [0..6]
  ).property()

  days: (->
    year = @get('year')
    month = @get('month')
    return [] unless year?
    return [] unless month?
    days = []
    d = moment "#{year}-#{month}-01"
    while d.month() is month - 1
      days.push(d)
      d = d.clone().add('days', 1)

    days
  ).property('year', 'month')

  daysGroupedByWeek: ( ->
    days = @get('days')
    weeks = [[]]
    index = -7
    firstWeekDay = days[0].day() - 1
    for i in [1..firstWeekDay]
      weeks[0].push "fnord"
    for i in [firstWeekDay..6]
      index += 1
      weeks[0].push days[i-firstWeekDay]
    while ((index += 7) < days.length)
      weeks.push(days.slice(index, index+7))

    weeks

  ).property('days')

