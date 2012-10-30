# If we save a record using ember-data's RESTadapter, and it fails, Rails
# returns the validation errors of the model as JSON hash:
#
# {"errors":{"name":["may not be blank"]}}
#
# This patches the RESTadapter to add these errors to the invalid record. It
# can be removed when the following Pull Request was merged into ember-data:
# https://github.com/emberjs/data/pull/376

DS.RESTAdapter.reopen
  createRecord: (store, type, record) ->
    root = this.rootForType(type)

    data = {}
    data[root] = record.toJSON(record, includeId: true)

    @ajax @buildURL(root), "POST",
      data: data,
      context: this,
      success: (json) ->
        @didCreateRecord(store, type, record, json)
      error: (xhr) ->
        if xhr.status == 422
          data = Ember.$.parseJSON xhr.responseText
          # we don't materialize the errors, so we cannot use them in a view :(
          store.recordWasInvalid record, data.errors

# TODO naive, does not consider translating the fields
DS.Model.reopen

  toJSONwithErrors: ->
    jQuery.extend @toJSON(), errors: @get('errors')

  # options: error, success (both functions)
  # TODO: switch to using record.one 'didCreate' from the isDirty & isValid
  observeSaveOnce: (options) ->
    callback = ->
      outcome = 'success'
      if @get('isDirty')
        return if @get('isValid') # not submitted yet
        outcome = 'error'

      (options[outcome] || Ember.K).call(this)

      @removeObserver('isDirty', callback)
      @removeObserver('isValid', callback)

    @addObserver('isDirty', callback)
    @addObserver('isValid', callback)

  errors: null
  errorMessages: (->
    messages = ''
    if @get('errors')?
      for field, errors of @get('errors')
        if errors
          for error in errors
            messages += "#{field} #{error} "
    messages
  ).property('isValid', 'errors', 'data')
  hasErrors: (->
    @get('errorMessages').match /\w+/
  ).property('errorMessages')
