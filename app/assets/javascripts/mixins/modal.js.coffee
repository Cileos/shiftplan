# TODO make this usable in a route
Clockwork.ModalMixin = Ember.Mixin.create
  classNames: ['modalor']
  layoutName: 'mixins/modal'
  heading: '<set a `heading` in your View>'
  didInsertElement: ->
    dialog = @$().dialog
      closeOnEscape: true
      modal: true
      title: @get('heading')
      resizable: no
      close: => @dialogclose(arguments)
      zIndex: 500

    # jQueryIU attaches a dialog box to the body by default. we want to react
    # to events in it and have to move it within our application.
    # OPTIMIZE: do not reappend dialog when ember is bound to body, too
    # also see http://bugs.jqueryui.com/ticket/7948 (parent option for jQUeryUI#dialog)
    dialog.parent('.ui-dialog').appendTo Clockwork.get('rootElement')

  willDestroyElement: ->
    @$().dialog('destroy')

  close: -> @$().dialog('close')

  # works almost all of the time
  backRoute: ['index']

  dialogclose: (event, ui) ->
    @get('controller.target').send('cancel', @get('backRoute') )

