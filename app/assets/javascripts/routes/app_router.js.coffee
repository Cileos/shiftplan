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


    newTask: (router, event) ->
      router.get('applicationController').openModal 'newTask', { milestone: event.context}

    newMilestone: Ember.Router.transitionTo 'milestones.new'
    milestones: ModalRouter.fullRoute(Shiftplan.Milestone, 'milestones')
