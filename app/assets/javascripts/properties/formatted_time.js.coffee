Clockwork.formattedTimeProperty = (name, format='H:mm')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(name)
      want = moment(value, format)
      @set name, moment(have).
                         clone().
                         hour(want.hour()).
                         minute(want.minute()).
                         toDate()

    have = @get(name)
    if have?
      moment(have).format(format)
    else
      have
  .property(name)
