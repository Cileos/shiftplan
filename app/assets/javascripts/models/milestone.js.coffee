Clockwork.Milestone = DS.Model.extend Clockwork.Doable,
  tasks: DS.hasMany('task')
  savedTasks: (->
    @get('tasks').filterProperty('isNew', false)
  ).property('tasks', 'tasks.@each.isNew')

  savedAndSortedTasks: (->
    @get('savedTasks').toArray().sort (a,b) ->
      if a.get('due_at')?
        if b.get('due_at')?
          a.get('due_at') - b.get('due_at')
        else
          -1 # b is null => to bottom
      else
        1 # a is null => to buttom
  ).property('savedTasks', 'savedTasks.@each.due_at')

  checkboxDisabled: (->
    if @get('savedTasks').every( (task) -> task.get('done') )
      undefined
    else
      'disabled'
  ).property('savedTasks', 'savedTasks.@each.done')

  tasksEnabledBinding: 'isLoaded'
