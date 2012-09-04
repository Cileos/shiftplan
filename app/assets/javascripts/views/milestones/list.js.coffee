Shiftplan.ListMilestonesView = Ember.View.extend
  templateName: 'milestones/list'
  milestonesBinding: 'Shiftplan.milestonesController'

  showNew: -> @set 'isNewVisible', true
  hideNew: -> @set 'isNewVisible', false
