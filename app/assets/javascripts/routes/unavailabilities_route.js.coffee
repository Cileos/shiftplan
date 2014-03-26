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
  model: ->
    @store.createRecord 'unavailability',
      startsAt:     null
      endsAt:       null
      startTime:    '06:00'
      endTime:      '18:00'
  renderTemplate: (controller)->
    @render 'unavailabilities/new'
