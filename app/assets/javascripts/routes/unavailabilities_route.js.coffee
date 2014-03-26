Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  serialize: (model, params)->
    {
      year: model.year
      month: model.month
    }
  setupController: (controller, model)->
    controller.set('year', model.year)
    controller.set('month', model.month)

Clockwork.UnavailabilitiesNewRoute = Ember.Route.extend
  model: (params, transition)->
    here = moment().
      year(transition.resolvedModels.unavailabilities.year).
      month(transition.resolvedModels.unavailabilities.month + 1).
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
