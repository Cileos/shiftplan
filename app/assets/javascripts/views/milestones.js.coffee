#= require views/modal
Shiftplan.MilestonesView = Shiftplan.ModalView.extend
  templateName: 'milestones'
  heading: 'Meilensteine' # TODO i18n
  newMilestone: ->
    Shiftplan.Milestone.createRecord()
