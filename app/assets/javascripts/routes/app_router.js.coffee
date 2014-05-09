# TODO remove when we have proper 'root.index' route
#      contains temporary root so a visit of the calendar page does
#      not create an extra entry in the browser history
Clockwork.Router.map ->
  @resource 'milestones', ->
    @route 'new'
    @resource 'milestone', path: ':milestone_id', ->
      @route 'edit'
      @route 'newTask'
      @route 'task', path: 'tasks/:task_id'


  @resource 'unavailabilities', path: 'unas/:eid/:year/:month', ->
    @route 'new', path: ':day/new'
    @route 'edit', path: 'edit/:id'

  @route 'scheduling', path: '/scheduling/:id'
  @route 'scheduling_comments', path: '/scheduling/:id/comments'

Clockwork.ApplicationRoute = Ember.Route.extend
  actions:
    save: (backRoute)->
      # handle variable number of arguments thanks to dynamic route segments
      mo = @modelFor(@get('controller.currentRouteName'))
      mo.get("errors").clear() # allows retry saving
      mo.save()
        .then =>
          @transitionTo backRoute...
        , =>
          # must be here to catch the error. We display the error(s) in the
          # form, retry possible.
          console?.debug "failed to #{@get('controller.currentRouteName')}", mo
    cancel: (backRoute)->
      # handle variable number of arguments thanks to dynamic route segments
      @modelFor(@get('controller.currentRouteName')).rollback()
      @transitionTo backRoute...
    doDelete: (backRoute)->
      # handle variable number of arguments thanks to dynamic route segments
      mo = @modelFor(@get('controller.currentRouteName'))
      mo.deleteRecord()
      mo.save()
        .then =>
          @transitionTo backRoute...
        , =>
          console?.debug "failed to delete", mo

Clockwork.IndexRoute = Ember.Route.extend
  beforeModel: ->
    if Clockwork.get('page') is 'milestones'
      @transitionTo 'milestones'
    else
      now = moment()
      @transitionTo 'unavailabilities', 'me', now.year(), now.month() + 1
