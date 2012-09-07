# TODO this should be a layout, nor?
Shiftplan.ModalView = Ember.View.extend
  classNames: ['modalor']
  layout: Ember.Handlebars.compile("{{yield}}")
  heading: ''
  didInsertElement: ->
    @$().dialog
      closeOnEscape: false
      modal: true
      title: @get('heading')
      close: @dialogclose

  dialogclose: (event, ui) ->
    Shiftplan.get('router').transitionTo('root.index')
