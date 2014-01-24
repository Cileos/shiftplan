# TODO remove when we have proper 'root.index' route
#      contains temporary root so a visit of the calendar page does
#      not create an extra entry in the browser history
Clockwork.Router.map ->
  @resource 'milestones', ->
    @route 'new'
  @resource 'milestone', path: '/milestone/:milestone_id', ->
    @route 'edit'
    @resource 'tasks', ->
      @route 'new'
    @route 'task', path: 'tasks/:task_id'

  # these are handled by routie and are just here to not confuse Ember
  @route 'scheduling', path: '/schedulings/:id'
  @route 'scheduling_comments', path: '/schedulings/:id/comments'

Clockwork.Router.reopen
  openModal: (opts...) ->
    # The used View must mixin Clockwork.ModalMixin
    @get('applicationController').connectOutlet 'modal', opts...
  closeModal: ->
    @get('applicationController').disconnectOutlet 'modal'

Clockwork.IndexRoute = Ember.Route.extend
  beforeModel: ->
    @transitionTo 'milestones'

Clockwork.MilestonesIndexRoute = Ember.Route.extend
  model: ->
    @store.find 'milestone'
  setupController: (controller)->
    console?.debug 'milestones setup controller', controller
