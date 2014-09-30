Clockwork.UnavailabilitiesRoute = Ember.Route.extend
  beforeModel: ()->
    user = @controllerFor('application').get('currentUser')
    if user.get('canManageUnavailabilities')
      @get('store').findQuery('employee', reason: 'unavailabilities').then (es)=>
        @set 'employees', es
    else
      @set 'employees', Ember.A()
  model: (params)->
    models = {} # hash of promises

    @set 'searchParams', params

    # not named employee_id to keep Ember from fetching the employee.
    employee_id = parseInt(params.eid) || null

    if employee_id
      models.employee = @get('employees').findProperty('id', params.eid)


    models.unas = if params.year? and params.month?
      # OPTIMIZE re-filter for the same params below
      @store.unloadAll 'unavailability' # we only want to see ours
      @store.find 'unavailability',
               year: params.year,
               month: params.month,
               employee_id: employee_id
    else
      Ember.A()


    Ember.RSVP.hash(models)

  setupController: (controller, model)->
    # transform the DS.PromiseFooArray into a real one so we can append new records to it
    # to a LiveArray so create/delete gets updates
    filtered = @store.filter 'unavailability', (una)->
      !una.get('isDeleted')
    @_super(controller, filtered)
    params = @get 'searchParams'
    controller.set('year', params.year)
    controller.set('month', params.month)
    controller.set('employees', @get('employees'))
    controller.set('employee', model.employee)

Clockwork.UnavailabilitiesIndexRoute = Ember.Route.extend
  setupController: -> # skip handling complex model wrong

Clockwork.UnavailabilitiesNewRoute = Ember.Route.extend
  model: (params, transition)->
    here = now().
      year( parseInt(transition.params.unavailabilities.year)).
      month(parseInt(transition.params.unavailabilities.month) - 1).
      date(params.day).
      startOf('day')
    @store.createRecord 'unavailability',
      startsAt:     here
      endsAt:       here
      allDay:       true
      startTime:    '06:00'
      endTime:      '18:00'
      employee:     @controllerFor('unavailabilities').get('employee')

  renderTemplate: (controller)->
    @render 'unavailabilities/new'

Clockwork.UnavailabilitiesEditRoute = Ember.Route.extend
  model: (params)->
    @store.find 'unavailability', params.id
  setupController: (controller, model)->
    @_super(controller, model)
    model.set 'date', model.get('startsAt')
