Clockwork.MilestoneTaskController = Ember.ObjectController.extend
  needs: ['employees']
  employeesBinding: 'controllers.employees'

Clockwork.MilestoneNewTaskController = Clockwork.MilestoneTaskController.extend()

# TODO inject all employees in all controllers like with currentUser
