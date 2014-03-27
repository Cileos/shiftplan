Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  model: (params)->
    @set 'searchParams', params
    return [] unless params.year?
    return [] unless params.month?
    @store.findQuery('unavailability', year: params.year, month: params.month)

  setupController: (controller, model)->
    controller.set('content', model)
    params = @get 'searchParams'
    controller.set('year', params.year)
    controller.set('month', params.month)

Clockwork.UnavailabilitiesNewRoute = Ember.Route.extend
  model: (params, transition)->
    here = moment().
      year(transition.params.unavailabilities.year).
      month(transition.params.unavailabilities.month + 1).
      date(params.day).
      startOf('day').
      toDate()
    @store.createRecord 'unavailability',
      date:         here
      startsAt:     null
      endsAt:       null
      startTime:    '06:00'
      endTime:      '18:00'
  renderTemplate: (controller)->
    @render 'unavailabilities/new'