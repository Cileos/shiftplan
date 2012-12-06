Clockwork.Task = DS.Model.extend Clockwork.Doable,
  milestone: DS.belongsTo('Clockwork.Milestone')
  can_manageBinding: 'Clockwork.session.can_manage_task'
