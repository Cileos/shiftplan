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
      connectOutlets: -> # nuffin
      openMilestones: Ember.Router.transitionTo('milestones')

    newMilestone: Ember.Router.transitionTo 'milestones.new'
    editMilestone: Ember.Router.transitionTo 'milestones.edit'

    milestones: Ember.Route.extend
      route: '/milestones'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet 'milestones', Shiftplan.Milestone.find()
      new: Ember.Route.extend
        route: '/new'
        connectOutlets: (router) ->
          router.openModal 'newMilestone', {}
        save: (router) ->
          if entered = router.get('newMilestoneController.content')
            transaction = Shiftplan.store.transaction()
            milestone = transaction.createRecord Shiftplan.Milestone, entered
            transaction.commit()
            router.transitionTo('milestones')
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) -> router.closeModal()
      doEdit: Ember.Router.transitionTo 'milestones.edit'
      edit: Ember.Route.extend
        route: '/edit/:milestone_id'
        connectOutlets: (router, milestone) ->
          router.openModal 'editMilestone', milestone
        save: (router) ->
          if milestone = router.get('editMilestoneController.content')
            transaction = Shiftplan.store.commit() # FIXME use transaction. somehow...
            router.transitionTo('milestones')
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) -> router.closeModal()
      delete: (router) ->
        if milestone = router.get('editMilestoneController.content')
          milestone.deleteRecord()
          milestone.store.commit()
          router.transitionTo('milestones')



