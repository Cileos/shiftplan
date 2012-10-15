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
        exit: (router) ->
          if milestones = router.get('milestonesController')
            milestones.disconnectOutlet()

