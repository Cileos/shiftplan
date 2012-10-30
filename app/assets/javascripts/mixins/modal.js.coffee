Shiftplan.ModalMixin = Ember.Mixin.create
  classNames: ['modalor']
  layout: Ember.Handlebars.compile("{{view Shiftplan.FlashMessagesView}}{{yield}}")
  heading: ''
  didInsertElement: ->
    dialog = @$().dialog
      closeOnEscape: false
      modal: true
      title: @get('heading')
      close: @dialogclose

    # jQueryIU attaches a dialog box to the body by default. we want to react
    # to events in it and have to move it within our application.
    # OPTIMIZE: do not reappend dialog when ember is bound to body, too
    # also see http://bugs.jqueryui.com/ticket/7948 (parent option for jQUeryUI#dialog)
    dialog.parent('.ui-dialog').appendTo Shiftplan.get('rootElement')


  close: -> @$().dialog('close')

  dialogclose: (event, ui) ->
    Shiftplan.store.commit()
    Shiftplan.get('router').transitionTo('root.index')

