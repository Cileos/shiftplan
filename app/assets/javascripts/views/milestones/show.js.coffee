Shiftplan.ShowMilestoneView = Ember.View.extend
  templateName: 'milestones/show'
  tagName: 'li'
  change: ->
    Shiftplan.store.commit()
  newTask: ->
    milestone = @get('content')
    Ember.assert "need milestone to create task", !!milestone
    task = Shiftplan.Task.createRecord(name: "Blob")
    milestone.get('tasks').pushObject task
    true
