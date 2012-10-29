# The used View must mixin Shiftplan.ModalMixin
Shiftplan.ApplicationController = Ember.Controller.extend
  openModal: (resource, opts...) ->
    @connectOutlet 'modal', resource, opts...
