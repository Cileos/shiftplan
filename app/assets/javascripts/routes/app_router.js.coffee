# =require routes/modal_router

Shiftplan.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'
  openModal: (opts...) ->
    # The used View must mixin Shiftplan.ModalMixin
    @get('applicationController').connectOutlet 'modal', opts...
  closeModal: ->
    @get('applicationController').disconnectOutlet 'modal'

  root: Ember.Route.extend

    index: Ember.Route.extend
      route: '/'
      connectOutlets: (router) -> router.transitionTo('milestones.index')


    newMilestone: Ember.Router.transitionTo 'milestones.new'
    milestones: ModalRouter.fullRoute(Shiftplan.Milestone, 'milestones').extend
      newTask: Ember.Router.transitionTo 'tasks.new'

      tasks: Ember.Route.extend
        route: '/tasks'
        index: Ember.Route.extend
          route: '/'
        new: ModalRouter.newRoute(Shiftplan.Task, 'milestones.index').extend
          route: '/:milestone_id/new'
          # :milestone_id causes the router not to return a hash, but only the
          # milestone. We need it as `milestone` attribute for the new record
          paramsForNewRecord: (router, milestone) -> { milestone: milestone }

        edit: ModalRouter.editRoute(Shiftplan.Task, 'milestones.index')

    editMilestone: Ember.Router.transitionTo 'milestones.edit'
    editTask: Ember.Router.transitionTo 'milestones.tasks.edit'
