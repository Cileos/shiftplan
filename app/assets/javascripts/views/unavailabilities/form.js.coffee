# =require views/modal_form
Clockwork.UnavailabilitiesFormView = Clockwork.ModalFormView.extend
  backRoute: Ember.computed ->
    date = moment( @get('controller.startsAt') )
    ['unavailabilities', date.year(), date.month() + 1]
  .property('content')
  heading: 'Wann kannste denn nich?'

