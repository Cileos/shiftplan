# =require routes/modal_router

Clockwork.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'
  openModal: (opts...) ->
    # The used View must mixin Clockwork.ModalMixin
    @get('applicationController').connectOutlet 'modal', opts...
  closeModal: ->
    @get('applicationController').disconnectOutlet 'modal'

  root: Ember.Route.extend

    newMilestone: Ember.Router.transitionTo 'milestones.new'
    milestones: ModalRouter.fullRoute(Clockwork.Milestone, 'milestones').extend
      # TODO remove when we have proper 'root.index' route
      #      This is the temporary root so a visit of the calendar page does
      #      not create an extra entry in the browser history
      route: '/'
      newTask: Ember.Router.transitionTo 'tasks.new'

      tasks: Ember.Route.extend
        route: '/tasks'
        index: Ember.Route.extend
          route: '/'
        new: ModalRouter.newRoute(Clockwork.Task, 'milestones.index').extend
          route: '/:milestone_id/new'
          # :milestone_id causes the router not to return a hash, but only the
          # milestone. We need it as `milestone` attribute for the new record
          paramsForNewRecord: (router, milestone) -> { milestone: milestone }

        edit: ModalRouter.editRoute(Clockwork.Task, 'milestones.index')

    editMilestone: Ember.Router.transitionTo 'milestones.edit'
    editTask: Ember.Router.transitionTo 'milestones.tasks.edit'

    # these are handled by routie and are just here to not confuse Ember
    scheduling: Ember.Route.extend
      route: '/scheduling/:id'
    schedulingComments: Ember.Route.extend
      route: '/scheduling/:id/comments'
