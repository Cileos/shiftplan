#= require views/modal
Shiftplan.NewMilestoneView = Shiftplan.ModalView.extend
  templateName: 'milestones/new'
  heading: 'neuer Meilenstein' # TODO i18n
  save: (e,x) ->
    e.preventDefault()
    e.stopPropagation()
    Shiftplan.get('router.milestonesController').createMilestone @get('milestoneName.value')
    @close()
