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

    newTask: (router, event) ->
      router.get('applicationController').openModal 'newTask', { milestone: event.context}

    milestones: Ember.Route.extend
      route: '/milestones'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet 'milestones', Shiftplan.Milestone.find()

      new: ModalRouter.newRoute(Shiftplan.Milestone, 'milestones')

      doEdit: Ember.Router.transitionTo 'milestones.edit'
      edit: ModalRouter.editRoute(Shiftplan.Milestone, 'milestones')
