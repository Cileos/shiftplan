formattedDateProperty = (name, format='L')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(name)
      want = moment(value, format)
      console?.debug "date", value, want
      @set name, moment(have).
                         clone().
                         year( want.year() ).
                         month( want.month() ).
                         date( want.date() ).
                         toDate()
    moment(@get(name)).format(format)
  .property(name)

formattedTimeProperty = (name, format='H:mm')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(name)
      want = moment(value, format)
      @set name, moment(have).
                         clone().
                         hour(want.hour()).
                         minute(want.minute()).
                         toDate()
    moment(@get(name)).format(format)
  .property(name)

# The Temporary is used in the creation form to allow start/end date for
# multiple unas  at once

Clockwork.Unavailability = DS.Model.extend
  reason: DS.attr('string')
  description: DS.attr('string')
  allDay: DS.attr('boolean')
  startsAt: DS.attr('date')
  endsAt: DS.attr('date')
  employee: DS.belongsTo('employee')
  account: DS.belongsTo('account')

  # this are currently needed for creation by time
  formattedDate:
    Ember.computed ->
      $.datepick.formatDate( @get('startsAt') )
    .property('startsAt')

  startDate: formattedDateProperty 'startsAt'
  endDate: formattedDateProperty 'endsAt'

  startTime: formattedTimeProperty 'startsAt'
  endTime: formattedTimeProperty 'endsAt'

  dayInWeek: (->
    moment(@get('startsAt')).day()
  ).property('startsAt')
  weekInYear: (->
    moment(@get('startsAt')).isoWeek()
  ).property('startsAt')

  reasonText: (->
    r = @get('reason')
    if r? and r.length > 0
      Em.I18n.t("activerecord.values.unavailability.reasons.#{r}")
    else
      null
  ).property('reason')

  timeRange: (->
    if @get('allDay')
      Em.I18n.t("activerecord.attributes.unavailability.all_day")
    else
      @get('startTime') + '-' + @get('endTime')
  ).property('allDay', 'startTime', 'endTime')

  allAccounts: true
  accounts: DS.hasMany('account')
