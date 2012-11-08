# Sets up routes to manage DS.Models in a modal box. You only have to extend your router with two methods:
#
#    App.Router = Ember.Router.extend
#      openModal: (opts...) ->
#        # The used View should handle the modal behaviour by using Ember's hooks didInsertElement etc
#        @get('applicationController').connectOutlet 'modal', opts...
#      closeModal: ->
#        @get('applicationController').disconnectOutlet 'modal'

ModalRouter = Ember.Namespace.create

  # @method newRoute
  # builds up a route to create a ember-data model in a modalbox.
  # @param model {DS.Model} ie. App.Post
  # @param parentPath {String} ie. 'posts' or 'root'

  newRoute: (model, parentPath) ->
    parts = model.toString().split(".")
    name = parts[parts.length - 1]

    view = "new#{name}"
    controller = "new#{name}Controller"
    contentInController = "#{controller}.content"
    transactionName = "#{controller}Transaction"

    Ember.Route.extend
      route: '/new'
      connectOutlets: (router) ->
        transaction = router.get('namespace.store').transaction()
        record = transaction.createRecord model
        router.set transactionName, transaction
        router.openModal view, record
      save: (router) ->
        if record = router.get(contentInController)
          transaction = router.get(transactionName)
          record.observeSaveOnce
            success: -> router.transitionTo(parentPath)
            error: ->
              newTransaction = router.get('namespace.store').transaction()
              newRecord = newTransaction.createRecord model, record.toJSON()
              newRecord.set 'errors', record.get('errors') # set by custom hook
              router.set transactionName, newTransaction
              router.set contentInController, newRecord
              transaction.rollback()
          transaction.commit()
      cancel: Ember.Route.transitionTo(parentPath)
      exit: (router) -> router.closeModal()

  # @method newRoute
  # builds up a route to edit a ember-data model in a modalbox.
  # @param model {DS.Model} ie. App.Post
  # @param parentPath {String} ie. 'posts' or 'root'
  editRoute: (model, parentPath) ->
    parts = model.toString().split(".")
    name = parts[parts.length - 1]

    view = "edit#{name}"
    controller = "edit#{name}Controller"
    contentInController = "#{controller}.content"
    transactionName = "#{controller}Transaction"

    Ember.Route.extend
      route: "/edit/:#{Ember.String.decamelize(name)}_id"
      connectOutlets: (router, record) ->
        transaction = router.get('namespace.store').transaction()
        transaction.add record
        router.set transactionName, transaction
        router.openModal view, record
      save: (router) ->
        if record = router.get(contentInController)
          transaction = router.get(transactionName)
          record.observeSaveOnce
            success: -> router.transitionTo(parentPath)
            error: ->
              # we cannot add a dirty record to a transaction and we cannot re-use a failed transaction
              # FIXME when we rollback a failed transaction with pre-existing
              # records, it does not remove the isDirty flag from the DS.Model
              changes = record.toJSON()
              newTransaction = router.get('namespace.store').transaction()
              transaction.rollback()
              newTransaction.add record
              record.setProperties changes
              router.set transactionName, newTransaction
          transaction.commit()
      cancel: (router) ->
        if transaction = router.get(transactionName)
          transaction.rollback()
        router.transitionTo(parentPath)
      exit: (router) -> router.closeModal()

      doDelete: (router) ->
        if record = router.get(contentInController)
          router.get(transactionName).rollback()
          transaction = router.get('namespace.store').transaction()
          transaction.add record
          record.deleteRecord()
          transaction.commit()
          router.transitionTo(parentPath)


window.ModalRouter = ModalRouter
