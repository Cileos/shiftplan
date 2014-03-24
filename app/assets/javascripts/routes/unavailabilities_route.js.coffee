
Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  model: (params)->
    controller = @controllerFor('unavailabilities')
    controller.set('year', params.year)
    controller.set('month', params.month)
    # TODO load unavailabilities from server, query
    @store.findQuery('unavailability', params)
