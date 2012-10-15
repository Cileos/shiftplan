Shiftplan.Doable = Ember.Mixin.create
  name: DS.attr('string')
  due_at: DS.attr('date')
  done: DS.attr('boolean')

  formatted_due_on: ( (key,value) ->
    format = Shiftplan.get('settings.dateFormat')
    if arguments.length is 1 # getter
      $.datepicker.formatDate format, @get('due_at')
    else
      @set('due_at', $.datepicker.parseDate(format, value))
      return value
  ).property('due_at', 'Shiftplan.settings.dateFormat')

  # as long as ember-data does not handle server-side validations, we have to do this manually
  validate: ->
    errors = Ember.Object.create()
    valid = true
    if !@get('name')? or @get('name.length') == 0 or @get('name').replace(/\s+/g,'').length == 0
      valid = false
      errors.set 'name', 'muss ausgefüllt werden'
    # ---------------
    unless valid
      @send 'becameInvalid', errors

    valid


