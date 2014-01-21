Clockwork.ModalMixin = Ember.Mixin.create
  classNames: ['modalor']
  layout: Ember.Handlebars.compile("{{yield}}")
  heading: '<set a `heading` in your View>'
  didInsertElement: ->
    dialog = @$().dialog
      closeOnEscape: false
      modal: true
      title: @get('heading')
      close: @dialogclose
      zIndex: 500

    # jQueryIU attaches a dialog box to the body by default. we want to react
    # to events in it and have to move it within our application.
    # OPTIMIZE: do not reappend dialog when ember is bound to body, too
    # also see http://bugs.jqueryui.com/ticket/7948 (parent option for jQUeryUI#dialog)
    dialog.parent('.ui-dialog').appendTo Clockwork.get('rootElement')

  willDestroyElement: ->
    @$().dialog('destroy')

  close: -> @$().dialog('close')

  dialogclose: (event, ui) ->
    Clockwork.get('router').send('cancel')

