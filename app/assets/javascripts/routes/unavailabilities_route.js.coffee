Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  beforeModel: ()->
    user = @controllerFor('application').get('currentUser')
    if user.get('canManageUnavailabilities')
      @get('store').findQuery('employee', reason: 'unavailabilities').then (es)=>
        @set 'employees', es
  model: (params)->
    models = {} # hash of promises

    @set 'searchParams', params

    # not named employee_id to keep Ember from fetching the employee.
    employee_id = parseInt(params.eid) || null

    if employee_id
      models.employee = @get('employees').findProperty('id', params.eid)

    if params.year? and params.month?
      models.unas = @store.findQuery 'unavailability',
               year: params.year,
               month: params.month,
               employee_id: employee_id
    else
      Ember.A()


    Ember.RSVP.hash(models)

  setupController: (controller, model)->
    # transform the DS.PromiseFooArray into a real one so we can append new records to it
    @_super(controller, model.unas.toArray())
    params = @get 'searchParams'
    controller.set('year', params.year)
    controller.set('month', params.month)
    controller.set('employees', @get('employees'))
    controller.set('employee', model.employee)

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
