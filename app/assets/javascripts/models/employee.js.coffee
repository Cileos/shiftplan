Clockwork.Employee = DS.Model.extend
  name: DS.attr('string')

  milestones: DS.hasMany('Clockwork.Milestone')

