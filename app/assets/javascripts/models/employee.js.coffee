Clockwork.Employee = DS.Model.extend
  name: DS.attr('string')

  milestones: DS.hasMany('milestone')
  tasks: DS.hasMany('task')

