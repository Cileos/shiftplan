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
  renderTemplate: (controller)->
    @render 'unavailabilities/new'
