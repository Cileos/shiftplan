Clockwork.formattedDateProperty = (source, format='L')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(source)
      want = moment(value, format)
      if want.isValid()
        have = if have?.isValid() then have else now()
        @set source, have.
                     clone().
                     year( want.year() ).
                     month( want.month() ).
                     date( want.date() )
    have = @get(source)
    if have && have.isValid()
      have.zone(timezoneOffset()).format(format)
    else
      null
  .property(source)
