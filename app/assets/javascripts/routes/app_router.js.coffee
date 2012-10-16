Shiftplan.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'
  root: Ember.Route.extend

    index: Ember.Route.extend
      route: '/'
      connectOutlets: -> # nuffin
      openMilestones: Ember.Router.transitionTo('milestones')

    milestones: Ember.Route.extend
      route: '/milestones'
      connectOutlets: (router) ->
        router.get('applicationController').connectModal 'milestones', Shiftplan.Milestone.find()
      newMilestone: Ember.Router.transitionTo 'milestones.new'
      editMilestone: Ember.Router.transitionTo 'milestones.edit'
      new: Ember.Route.extend
        route: '/new'
        connectOutlets: (router) ->
          if milestones = router.get('milestonesController')
            milestones.connectOutlet 'newMilestone', {}
          else
            alert "no milestones view found to connect outlet for new to"
        save: (router) ->
          if entered = router.get('newMilestoneController.content')
            transaction = Shiftplan.store.transaction()
            milestone = transaction.createRecord Shiftplan.Milestone, entered
            transaction.commit()
            router.transitionTo('milestones')
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) ->
          if milestones = router.get('milestonesController')
            milestones.disconnectOutlet()
      edit: Ember.Route.extend
        route: '/edit/:milestone_id'
        connectOutlets: (router, milestone) ->
          if milestones = router.get('milestonesController')
            milestones.connectOutlet 'editMilestone', milestone
          else
            alert "no milestones view found to connect outlet for new to"
        save: (router) ->
          if milestone = router.get('editMilestoneController.content')
            transaction = Shiftplan.store.commit() # FIXME use transaction. somehow...
            router.transitionTo('milestones')
        cancel: Ember.Route.transitionTo('milestones')
        exit: (router) ->
          if milestones = router.get('milestonesController')
            milestones.disconnectOutlet()
      delete: (router) ->
        if milestone = router.get('editMilestoneController.content')
          milestone.deleteRecord()
          milestone.store.commit()
          router.transitionTo('milestones')



