Clockwork.formattedDateProperty = (name, format='L')->
  Ember.computed (key, value)->
    if arguments.length > 1
      have = @get(name)
      want = moment(value, format)
      @set name, moment(have).
                         clone().
                         year( want.year() ).
                         month( want.month() ).
                         date( want.date() ).
                         toDate()
    moment(@get(name)).format(format)
  .property(name)
