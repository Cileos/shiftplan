Clockwork.Employee = DS.Model.extend
  name: DS.attr('string')
  account: DS.belongsTo('account')

  milestones: DS.hasMany('milestone')
  tasks: DS.hasMany('task')

