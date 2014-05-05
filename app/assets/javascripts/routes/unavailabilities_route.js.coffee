Clockwork.UnavailabilitiesIndexRoute = Ember.Route.extend
  beforeModel: (transition,x,y)->
    user = @controllerFor('application').get('currentUser')
    if user.get('canManageEmployees')
      console?.debug "master blaster"
    params = transition.params[@get('routeName')]
    debugger
    unas = if params.year? and params.month?
             @store.findQuery('unavailability', year: params.year, month: params.month, employee_id: params.employee_id)
           else
             Ember.A()
    @set 'unas', unas
    unas
  model: (params)->
    @set 'searchParams', params
    unas = @get 'unas'
    # transform the DS.PromiseFooArray into a real one so we can append new records to it
    unas.toArray()

  setupController: (controller, model)->
    @_super(controller, model)
    params = @get 'searchParams'
    controller.set('year', params.year)
    controller.set('month', params.month)

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
