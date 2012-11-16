Shiftplan.Milestone = DS.Model.extend Shiftplan.Doable,
  tasks: DS.hasMany('Shiftplan.Task')
  savedTasks: (->
    @get('tasks').filterProperty('isNew', false).toArray().sort (a,b) -> a.get('id') - b.get('id')
  ).property('tasks', 'tasks.@each.isNew')

  tasksEnabledBinding: 'isLoaded'

