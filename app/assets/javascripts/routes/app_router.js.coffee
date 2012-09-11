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
        router.get('applicationController').connectModal 'milestones', Shiftplan.store.find(Shiftplan.Milestone)
