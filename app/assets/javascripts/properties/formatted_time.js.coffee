Clockwork.formattedTimeProperty = (source, format='H:mm')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(source)
      want = moment(value, format)
      if want.isValid()
        have = if have?.isValid() then have else now()
        @set source, have.
                     clone().
                     hour(want.hour()).
                     minute(want.minute())

    have = @get(source)
    if have && have.isValid()
      have.format(format)
    else
      have
  .property(source)
