Shiftplan.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'
  root: Ember.Route.extend

    index: Ember.Route.extend
      route: '/'
      connectOutlets: Ember.Router.transitionTo('milestones')

    milestones: Ember.Route.extend
      route: '/milestones'
      showNewMilestone: Ember.Router.transitionTo('milestones.new')

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet 'milestones', Shiftplan.store.find(Shiftplan.Milestone)

      new: Ember.Route.extend
        route: '/new'
        connectOutlets: (router) ->
          router.get('applicationController').connectOutlet 'modal', 'modal'
          router.get('modalController').connectOutlet 'newMilestone'
