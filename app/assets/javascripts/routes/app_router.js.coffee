# TODO remove when we have proper 'root.index' route
#      contains temporary root so a visit of the calendar page does
#      not create an extra entry in the browser history
Clockwork.Router.map ->
  @resource 'milestones', ->
    @route 'new'
    @route 'edit', path: ':milestone_id'
  @resource 'milestone', path: '/milestone/:milestone_id', ->
    @route 'newTask'
    @route 'task', path: 'tasks/:task_id'

  # these are handled by routie and are just here to not confuse Ember
  @route 'scheduling', path: '/schedulings/:id'
  @route 'scheduling_comments', path: '/schedulings/:id/comments'

Clockwork.ApplicationRoute = Ember.Route.extend
  model: ->
    Em.RSVP.hash
      employees: @store.find('employee')
      milestones: @store.find('milestone')
  setupController: (controller, model)->
    # populate forms
    @controllerFor('employees').set('model', model.employees)
    # always rendered
    @controllerFor('milestones').set('model', model.milestones)

Clockwork.IndexRoute = Ember.Route.extend
  beforeModel: ->
    @transitionTo 'milestones'

Clockwork.MilestonesRoute = Ember.Route.extend
  model: ->
    @store.find 'milestone'
  render: -> #nothing, we render it permanentely in application.hb


milestoneModalActions =
  save: ->
    mo = @modelFor(@routeName)
    mo.get("errors").clear() # allows retry saving
    mo.save()
      .then =>
        @transitionTo 'milestones'
      , =>
        # must be here to catch the error. We display the error(s) in the
        # form, retry possible.
        console?.debug "failed to #{@routeName} milestone"
  cancel: ->
    @modelFor(@routeName).rollback()
    @transitionTo 'milestones'
  doDelete: ->
    mo = @modelFor(@routeName)
    mo.deleteRecord()
    mo.save()
      .then =>
        @transitionTo 'milestones'
      , =>
        console?.debug "failed to delete milestone, try again later"

Clockwork.MilestonesEditRoute = Ember.Route.extend
  actions: milestoneModalActions

Clockwork.MilestonesNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord 'milestone',
      name:            ''
      due_at:           null
      description:      ''
      responsible:      null
  actions: milestoneModalActions

Clockwork.MilestoneTaskRoute = Ember.Route.extend
  actions: milestoneModalActions

Clockwork.MilestoneNewTaskRoute = Ember.Route.extend
  beforeModel: (transition)->
    if m = transition.providedModels.milestone
      @set 'milestone', m
    else
      @store.find('milestone', transition.params.milestone_id).then (ms)=>
        @set 'milestone', ms
  model: (_, transition)->
    task = @store.createRecord 'task',
      name:            ''
      due_at:           null
      description:      ''
      responsible:      null
      milestone:        @get('milestone')

  actions: milestoneModalActions
