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

  @resource 'unavailabilities', path: 'una/:year/:month', ->
    @route 'new', path: ':day/new'

  @route 'scheduling', path: '/scheduling/:id'
  @route 'scheduling_comments', path: '/scheduling/:id/comments'

Clockwork.ApplicationRoute = Ember.Route.extend
  actions:
    save: (backRoute)->
      mo = @modelFor(@get('controller.currentRouteName'))
      mo.get("errors").clear() # allows retry saving
      mo.save()
        .then =>
          @transitionTo backRoute
        , =>
          # must be here to catch the error. We display the error(s) in the
          # form, retry possible.
          console?.debug "failed to #{@get('controller.currentRouteName')}", mo
    cancel: (backRoute)->
      @modelFor(@get('controller.currentRouteName')).rollback()
      @transitionTo backRoute
    doDelete: (backRoute)->
      mo = @modelFor(@get('controller.currentRouteName'))
      mo.deleteRecord()
      mo.save()
        .then =>
          @transitionTo backRoute
        , =>
          console?.debug "failed to delete", mo

Clockwork.IndexRoute = Ember.Route.extend
  beforeModel: ->
    if Clockwork.get('page') is 'milestones'
      @transitionTo 'milestones'
    else
      now = moment()
      @transitionTo 'unavailabilities.index', year: now.year(), month: now.month() + 1


