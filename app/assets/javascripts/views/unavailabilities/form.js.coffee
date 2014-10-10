# =require views/modal_form
Clockwork.UnavailabilitiesFormView = Clockwork.ModalFormView.extend
  backRoute:
    Ember.computed ->
      date = moment( @get('controller.startsAt') )
      eid = @get('controller.employeeId')
      ['unavailabilities', eid, date.year(), date.month() + 1]
    .property('content')
  heading:
    Ember.computed ->
      if name = @get('content.employee.name')
        Ember.I18n.t('unavailabilities.new.modal_title.employee', name: name, date: @get('controller.formattedDate'))
      else
        Ember.I18n.t('unavailabilities.new.modal_title.self', date: @get('controller.formattedDate'))
    .property('content.employee')

