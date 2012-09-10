Shiftplan.ShowMilestoneView = Ember.View.extend
  templateName: 'milestones/show'
  tagName: 'li'
  change: ->
    Shiftplan.store.commit()
