Clockwork.formattedDateProperty = (name, format='L')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(name)
      want = moment(value, format)
      if want.isValid()
        @set name, moment(have).
                           clone().
                           year( want.year() ).
                           month( want.month() ).
                           date( want.date() ).
                           toDate()
    have = @get(name)
    if have?
      moment(have).format(format)
    else
      have
  .property(name)
