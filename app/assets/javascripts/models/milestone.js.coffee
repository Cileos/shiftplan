Shiftplan.Milestone = DS.Model.extend Shiftplan.Doable,
  tasks: DS.hasMany('Shiftplan.Task')
  savedTasks: (->
    @get('tasks').filterProperty('isNew', false)
  ).property('tasks', 'tasks.@each.isNew')

  tasksEnabled: true

