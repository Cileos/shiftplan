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
      dueAt:            null
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
      dueAt:            null
      description:      ''
      responsible:      null
      milestone:        @get('milestone')

  actions: milestoneModalActions

