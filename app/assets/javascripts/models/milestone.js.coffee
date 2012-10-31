Shiftplan.Milestone = DS.Model.extend Shiftplan.Doable,
  tasks: DS.hasMany('Shiftplan.Task')

  # @wip for now, have to do other stuff first
  tasksEnabled: true

