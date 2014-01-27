# If we save a record using ember-data's RESTadapter, and it fails, Rails
# returns the validation errors of the model as JSON hash:
#
# {"errors":{"name":["may not be blank"]}}
#
# the ActiveModelAdapter adds a DS.Errors object to #errors
#
# TODO naive, does not consider translating the fields
DS.Model.reopen
  errorMessages: (->
    messages = ''
    unless @get('errors.isEmpty')
      for error in @get('errors.content')
        messages += "#{error.attribute} #{error.message} "
    messages
  ).property('isValid', 'errors', 'data')
  hasErrors: (->
    !@get('isValid') and @get('errorMessages').match /\w+/
  ).property('errorMessages', 'isValid')
