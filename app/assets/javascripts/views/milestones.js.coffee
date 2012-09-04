Shiftplan.MilestonesView = Ember.View.extend
  templateName: 'milestones'

  isNewVisible: false

  showNew: -> @set 'isNewVisible', true
  hideNew: -> @set 'isNewVisible', false
