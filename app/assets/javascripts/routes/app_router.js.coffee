Shiftplan.Router = Ember.Router.extend
  location: 'hash'
  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'

      showNewMilestone: Ember.Router.transitionTo('newMilestone')

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet 'milestones', Shiftplan.store.find(Shiftplan.Milestone)

    newMilestone: Ember.Route.extend
      route: 'milestones/new'
      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet 'modal', 'modal'
        router.get('modalController').connectOutlet 'newMilestone'
