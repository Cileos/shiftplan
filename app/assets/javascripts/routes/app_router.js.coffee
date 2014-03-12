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

  @route 'scheduling', path: '/schedulings/:id'
  @route 'scheduling_comments', path: '/scheduling/:id/comments'

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


