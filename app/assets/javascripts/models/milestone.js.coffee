Shiftplan.Milestone = DS.Model.extend Shiftplan.Doable,
  tasks: DS.hasMany('Shiftplan.Task')
  savedTasks: (->
    @get('tasks').filterProperty('isNew', false)
  ).property('tasks', 'tasks.@each.isNew')

  savedAndSortedTasks: (->
    @get('savedTasks').toArray().sort (a,b) -> a.get('id') - b.get('id')
  ).property('savedTasks', 'savedTasks.@each.id')

  checkboxDisabled: (->
    if @get('savedTasks').every( (task) -> task.get('done') )
      undefined
    else
      'disabled'
  ).property('savedTasks', 'savedTasks.@each.done')

  tasksEnabledBinding: 'isLoaded'

