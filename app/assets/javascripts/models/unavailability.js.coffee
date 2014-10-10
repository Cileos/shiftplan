Clockwork.Unavailability = DS.Model.extend
  reason: DS.attr('string')
  description: DS.attr('string')
  allDay: DS.attr('boolean')
  startsAt: DS.attr('moment')
  endsAt: DS.attr('moment')
  employee: DS.belongsTo('employee')
  account: DS.belongsTo('account')

  # this are currently needed for creation by time
  formattedDate:
    Ember.computed ->
      @get('startsAt').format('L')
    .property('startsAt')

  startDate: Clockwork.formattedDateProperty 'startsAt'
  endDate: Clockwork.formattedDateProperty 'endsAt'

  startTime: Clockwork.formattedTimeProperty 'startsAt'
  endTime: Clockwork.formattedTimeProperty 'endsAt'

  dayInWeek: Ember.computed 'startsAt', ->
    @get('startsAt')?.day()
  weekInYear: Ember.computed 'startsAt', ->
    @get('startsAt')?.isoWeek()

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
