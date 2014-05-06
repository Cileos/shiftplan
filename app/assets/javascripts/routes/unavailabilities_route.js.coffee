Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  beforeModel: ()->
    user = @controllerFor('application').get('currentUser')
    if user.get('canManageUnavailabilities')
      @set 'employees', @get('store').findQuery('employee', reason: 'unavailabilities')
  model: (params)->
    @set 'searchParams', params

    if params.year? and params.month?
      empl = parseInt(params.eid) || null # not named employee_id to keep Ember from fetching the employee.
      @store.findQuery('unavailability', year: params.year, month: params.month, employee_id: empl)
    else
      Ember.A()

  setupController: (controller, model)->
    # transform the DS.PromiseFooArray into a real one so we can append new records to it
    @_super(controller, model.toArray())
    params = @get 'searchParams'
    controller.set('year', params.year)
    controller.set('month', params.month)
    controller.set('employees', @get('employees'))

Clockwork.UnavailabilitiesNewRoute = Ember.Route.extend
  model: (params, transition)->
    here = moment().
      year( parseInt(transition.params.unavailabilities.year)).
      month(parseInt(transition.params.unavailabilities.month) - 1).
      date(params.day).
      startOf('day')
    @store.createRecord 'unavailability',
      date:         here.toDate()
      startsAt:     null
      endsAt:       null
      startTime:    '06:00'
      endTime:      '18:00'
  renderTemplate: (controller)->
    @render 'unavailabilities/new'

  deactivate: ->
    if @currentModel.get('id')
      @modelFor('unavailabilities').pushObject @currentModel
      @controllerFor('unavailabilities').notifyPropertyChange 'content'

Clockwork.UnavailabilitiesEditRoute = Ember.Route.extend
  model: (params)->
    @store.find 'unavailability', params.id
