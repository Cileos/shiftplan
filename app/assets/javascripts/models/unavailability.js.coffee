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

  startDate: Clockwork.formattedDateProperty 'startsAt'
  endDate: Clockwork.formattedDateProperty 'endsAt'

  startTime: Clockwork.formattedTimeProperty 'startsAt'
  endTime: Clockwork.formattedTimeProperty 'endsAt'

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
