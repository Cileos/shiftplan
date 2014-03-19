Clockwork.SchedulingRoute = Ember.Route.extend
  setupController: (controller, model) ->
    cursor = Clockwork.get('cursor')
    $scheduling = cursor.findByCid(model.id)
    if $scheduling.length == 1
      cursor.focus($scheduling)
      cursor.activate() unless cursor.isReadonly()

Clockwork.SchedulingCommentsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    cursor = Clockwork.get('cursor')
    $scheduling = cursor.findByCid(model.id)
    if $scheduling.length == 1
      cursor.focus($scheduling)
      $scheduling.find('a.comments, a.no-comments').click()
