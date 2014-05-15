# =require views/modal_form
Clockwork.UnavailabilitiesFormView = Clockwork.ModalFormView.extend
  backRoute: Ember.computed ->
    date = moment( @get('controller.startsAt') )
    ['unavailabilities', (@get('content.employee.id') || 'me'), date.year(), date.month() + 1]
  .property('content')
  heading:
    Ember.computed ->
      if name = @get('content.employee.name')
        Ember.I18n.t('unavailabilities.new.modal_title.employee', name: name)
      else
        Ember.I18n.t('unavailabilities.new.modal_title.self')
    .property('content.employee')

