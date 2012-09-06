Shiftplan.ModalView = Ember.View.extend
  classNames: ['modalor']
  didInsertElement: -> @$().dialog()
  template: Ember.Handlebars.compile("{{outlet}}")
