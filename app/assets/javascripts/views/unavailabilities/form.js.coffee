# =require views/modal_form
Clockwork.UnavailabilitiesFormView = Clockwork.ModalFormView.extend
  backRoute: Ember.computed ->
    date = moment( @get('controller.startsAt') )
    ['unavailabilities', @get('controller.employee.id'), date.year(), date.month() + 1]
  .property('content')
  heading:
    Ember.computed ->
      if name = @get('content.employee.name')
        "Wann kann #{name} denn nich?"
      else
        'Wann kannste denn nich?'
    .property('content.employee')

