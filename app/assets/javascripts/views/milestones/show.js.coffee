Shiftplan.ShowMilestoneView = Ember.View.extend
  templateName: 'milestones/show'
  tagName: 'li'
  newTask: ->
    milestone = @get('content')
    Ember.assert "need milestone to create task", !!milestone
    task = Shiftplan.Task.createRecord()
    milestone.get('tasks').pushObject task
    true
