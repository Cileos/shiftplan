Clockwork.Milestone = DS.Model.extend Clockwork.Doable,
  tasks: DS.hasMany('task')
  savedTasks: (->
    @get('tasks').filterProperty('isNew', false)
  ).property('tasks', 'tasks.@each.isNew')

  savedAndSortedTasks: (->
    @get('savedTasks').toArray().sort (a,b) ->
      if a.get('dueAt')?
        if b.get('dueAt')?
          a.get('dueAt') - b.get('dueAt')
        else
          -1 # b is null => to bottom
      else
        1 # a is null => to buttom
  ).property('savedTasks', 'savedTasks.@each.dueAt')

  checkboxDisabled: (->
    if @get('savedTasks').every( (task) -> task.get('done') )
      undefined
    else
      'disabled'
  ).property('savedTasks', 'savedTasks.@each.done')

  tasksEnabledBinding: 'isLoaded'
