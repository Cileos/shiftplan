Clockwork.MilestonesRoute = Ember.Route.extend
  model: ->
    Em.RSVP.hash
      employees: @store.find('employee')
      milestones: @store.find('milestone')
  setupController: (controller, model)->
    controller.set 'model', model.milestones
    # populate forms
    @controllerFor('employees').set('model', model.employees)

  renderTemplate: -> #nothing, we render it permanentely in application.hb
    @render 'milestones'

Clockwork.MilestonesNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord 'milestone',
      name:            ''
      dueAt:            null
      description:      ''
      responsible:      null

Clockwork.MilestoneNewTaskRoute = Ember.Route.extend
  beforeModel: (transition)->
    if m = transition.providedModels.milestone
      @set 'milestone', m
    else
      @store.find('milestone', transition.params.milestone_id).then (ms)=>
        @set 'milestone', ms
  model: (_, transition)->
    task = @store.createRecord 'task',
      name:            ''
      dueAt:            null
      description:      ''
      responsible:      null
      milestone:        @get('milestone')
