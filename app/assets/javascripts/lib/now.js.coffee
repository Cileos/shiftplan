# supplies the server timezone to ember apps. Instead of using `moment()` for
# the current time, use `now()`. It is also advised to use it when creating new
# timestamps by modifying them later, for example
# `now().year(2000).startOfYear()` to celebrate exactly at the local party
window.timeZoneName = ->
  $('head > meta[name=timezonename]').prop('content')

window.now = ->
  zoneName = timeZoneName()
  moment().clone().tz(zoneName)
