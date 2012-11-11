Clockwork.Milestone = DS.Model.extend Clockwork.Doable,
  tasks: DS.hasMany('Clockwork.Task')

  # @wip for now, have to do other stuff first
  tasksEnabled: true

