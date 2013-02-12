# Sets up routes to manage DS.Models in a modal box. You only have to extend your router with two methods:
#
#    App.Router = Ember.Router.extend
#      openModal: (opts...) ->
#        # The used View should handle the modal behaviour by using Ember's hooks didInsertElement etc
#        @get('applicationController').connectOutlet 'modal', opts...
#      closeModal: ->
#        @get('applicationController').disconnectOutlet 'modal'
#
# Then you can setup a full route or just parts:
#
#    App.Router = Ember.Router.extend # continued
#      root:
#         posts: ModalRouter.fullRoute(App.Post, 'posts')
#
#         feedbacks: ModalRouter.newRoute(App.Feedback, 'root')
#
#         # and you can even add more routes by extending the returned route as usual
#
#         comments: ModalRouter.fullRoute(App.Comment, 'comments').extend
#          ratings: Ember.Route.extend
#            # ....

modelName = (model) ->
  parts = model.toString().split(".")
  parts[parts.length - 1]

ModalRouter = Ember.Namespace.create

  # @method fullRoute
  # builds up a route to manage a ember-data model in a modalbox, including a list, create, edit and delete
  # @param model {DS.Model} ie. App.Post
  # @param routeName {String} ie. 'posts', should be the same as the propery you assign this route to
  fullRoute: (model, routeName) ->
    Ember.Route.extend
      route: "/#{routeName}" # convention: path segment == route string

      index: Ember.Route.extend
        route: '/' # to make ember happy, see http://emberjs.com/api/classes/Ember.Router.html "Adding Nested Routes to a Router"
        connectOutlets: (router) ->
          router.get('applicationController').connectOutlet routeName, model.filter( (record) -> not record.get('isNew') )

      new: ModalRouter.newRoute(model, "#{routeName}.index")

      doEdit: Ember.Router.transitionTo "#{routeName}.edit"
      edit: ModalRouter.editRoute(model, "#{routeName}.index")


  # @method newRoute
  # builds up a route to create a ember-data model in a modalbox.
  #
  # To open a Modalbox to create a Thing with default value for parent, you can
  #
  #    router.transitionTo 'things.new', parent: theParent.get('id'), name: "My thing"
  #
  # @param model {DS.Model} ie. App.Post
  # @param parentPath {String} ie. 'posts' or 'root'

  newRoute: (model, parentPath) ->
    name = modelName model

    view = "new#{name}"
    controller = "new#{name}Controller"
    contentInController = "#{controller}.content"
    transactionName = "#{controller}Transaction"

    Ember.Route.extend
      route: '/new'
      # default: forward the context as auto-detected by ember
      paramsForNewRecord: (router, params) -> params
      connectOutlets: (router, params) ->
        console?.debug "route params for #{model.toString()}:", params
        newParams = @paramsForNewRecord router, params
        console?.debug "used to createRecord:", newParams
        transaction = router.get('namespace.store').transaction()
        record = transaction.createRecord model, newParams
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
      cancel: (router) ->
        if transaction = router.get(transactionName)
          transaction.rollback()
        router.transitionTo(parentPath)
      exit: (router) -> router.closeModal()

  # @method newRoute
  # builds up a route to edit a ember-data model in a modalbox.
  # @param model {DS.Model} ie. App.Post
  # @param parentPath {String} ie. 'posts' or 'root'
  editRoute: (model, parentPath) ->
    name = modelName model

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
              # FIXME remove when ember fixed their bugs
              record.set 'isDirty', false
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
