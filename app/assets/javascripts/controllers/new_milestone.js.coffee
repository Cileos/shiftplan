# TODO inject all employees in all controllers like with currentUser
Clockwork.MilestoneController = Ember.ObjectController.extend
  needs: ['employees']
  employeesBinding: 'controllers.employees'
Clockwork.MilestonesNewController = Clockwork.MilestoneController.extend
  needs: ['employees']
  employeesBinding: 'controllers.employees'
Clockwork.MilestonesEditController = Clockwork.MilestoneController.extend
  needs: ['employees']
  employeesBinding: 'controllers.employees'
