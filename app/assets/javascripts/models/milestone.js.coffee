Shiftplan.Milestone = DS.Model.extend Shiftplan.Doable,
  tasks: DS.hasMany('Shiftplan.Task')

  tasksEnabled: true

