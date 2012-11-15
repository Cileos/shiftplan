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
      connectOutlets: (router) -> router.transitionTo('milestones')


    newMilestone: Ember.Router.transitionTo 'milestones.new'
    milestones: ModalRouter.fullRoute(Shiftplan.Milestone, 'milestones').extend
      newTask: (router, event) -> router.transitionTo 'tasks.new', milestone: event.context.get('id')

      tasks: Ember.Route.extend
        route: '/tasks'
        new: ModalRouter.newRoute(Shiftplan.Task, 'tasks').extend
          route: '/new/:milestone'

