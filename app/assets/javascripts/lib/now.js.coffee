# supplies the server timezone to ember apps. Instead of using `moment()` for
# the current time, use `now()`. It is also advised to use it when creating new
# timestamps by modifying them later, for example
# `now().year(2000).startOfYear()` to celebrate exactly at the local party
window.timezoneOffset = ->
  $('head > meta[name=timezoneoffset]').prop('content')

window.now = ->
  offset = timezoneOffset()

  # take the global "now", shift perspective to current timezone
  # example: 09:30+02:00 (Knoppers) => 04:30-03:00 (atlantic fish still sleeping)
  shifted = moment().zone(offset)

  # gives us the width of the shift from the browser's zone
  # example: from +2 to -3 => 5 hours => 300 minutes
  shift = shifted.zone() - moment().zone()

  # compansate for the shift. it's time should now equal the server's
  # example 04:30-03:00 => 09:30-03:00 (atlantic fish may have knoppers now)
  shifted.add(shift, 'minute')

  shifted
