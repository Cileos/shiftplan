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
          transaction = Shiftplan.store.transaction()
          milestone = transaction.createRecord Shiftplan.Milestone
          router.set 'currentTransaction', transaction
          router.openModal 'newMilestone', milestone
        save: (router) ->
          if milestone = router.get('newMilestoneController.content')
            transaction = router.get('currentTransaction')
            milestone.observeSaveOnce
              success: -> router.transitionTo('milestones')
              error: ->
                newTransaction = Shiftplan.store.transaction()
                newMilestone = newTransaction.createRecord Shiftplan.Milestone, milestone.toJSON()
                newMilestone.set 'errors', milestone.get('errors') # set by custom hook
                router.set 'currentTransaction', newTransaction
                router.set 'newMilestoneController.content', newMilestone
                transaction.rollback()
            transaction.commit()
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) -> router.closeModal()

      doEdit: Ember.Router.transitionTo 'milestones.edit'
      edit: Ember.Route.extend
        route: '/edit/:milestone_id'
        connectOutlets: (router, milestone) ->
          transaction = Shiftplan.store.transaction()
          transaction.add milestone
          router.set 'currentTransaction', transaction
          router.openModal 'editMilestone', milestone
        save: (router) ->
          if milestone = router.get('editMilestoneController.content')
            transaction = router.get('currentTransaction')
            milestone.observeSaveOnce
              success: -> router.transitionTo('milestones')
              error: ->
                # we cannot add a dirty record to a transaction and we cannot re-use a failed transaction
                # FIXME when we rollback a failed transaction with pre-existing
                # records, it does not remove the isDirty flag from the DS.Model
                changes = milestone.toJSON()
                newTransaction = Shiftplan.store.transaction()
                transaction.rollback()
                newTransaction.add milestone
                milestone.setProperties changes
                router.set 'currentTransaction', newTransaction
            transaction.commit()
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) -> router.closeModal()
      delete: (router) ->
        if milestone = router.get('editMilestoneController.content')
          milestone.deleteRecord()
          milestone.store.commit()
          router.transitionTo('milestones')



