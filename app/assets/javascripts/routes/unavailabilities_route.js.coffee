Clockwork.UnavailabilitiesIndexRoute = Ember.Route.extend
  serialize: (model, params)->
    {
      year: model.year
      month: model.month
    }
  setupController: (controller, model)->
    controller.set('year', model.year)
    controller.set('month', model.month)
