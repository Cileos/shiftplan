formattedTimeProperty = (name)->
  Ember.computed (key, value)->
    if arguments.length > 1
      date = @get('date') || @get('startsAt')
      splot = value.split(':')
      @set name, moment(date).
                         clone().
                         hour(splot[0]).
                         minute(splot[1]).
                         toDate()
    moment(@get(name)).format('H:mm')
  .property(name)



Clockwork.Unavailability = DS.Model.extend
  reason: DS.attr('string')
  description: DS.attr('string')
  allDay: DS.attr('boolean')
  startsAt: DS.attr('date')
  endsAt: DS.attr('date')
  employee: DS.belongsTo('employee')
  account: DS.belongsTo('account')

  # this are currently needed for creation by time
  date: null
  formattedDate:
    Ember.computed ->
      $.datepick.formatDate( @get('date') )
    .property('date')

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
