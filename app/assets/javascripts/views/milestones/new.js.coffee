#= require views/modal
Shiftplan.NewMilestoneView = Shiftplan.ModalView.extend
  templateName: 'milestones/new'
  heading: 'neuer Meilenstein' # TODO i18n
  submit: (event) ->
    debugger
    #value = @get('value')
    #if value
    #  @get('parentView').get('controller').createMilestone(value)
    #  @get('parentView').hideNew()
