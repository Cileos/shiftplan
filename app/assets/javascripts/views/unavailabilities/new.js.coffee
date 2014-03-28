Clockwork.UnavailabilitiesNewView = Ember.View.extend Clockwork.ModalMixin, Ember.I18n.TranslateableProperties,
  buttonLabelTranslation: "helpers.actions.create"
  heading: 'Wann kannste denn nich?'
  tagName: 'form'
  backRoute: Ember.computed ->
    date = moment( @get('controller.date') )
    ['unavailabilities.index', date.year(), date.month() + 1]
  .property('content')
