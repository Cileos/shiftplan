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

  @route 'unavailabilities', path: 'una/:year/:month'

  @route 'scheduling', path: '/scheduling/:id'
  @route 'scheduling_comments', path: '/scheduling/:id/comments'

Clockwork.ApplicationRoute = Ember.Route.extend()

Clockwork.IndexRoute = Ember.Route.extend
  beforeModel: ->
    if Clockwork.get('page') is 'milestones'
      @transitionTo 'milestones'
    else
      # FIXME dynamic NOW
      now = moment()
      @transitionTo 'unavailabilities', year: now.year(), month: now.month()


