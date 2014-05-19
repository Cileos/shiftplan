#= require test/sinon-timers-1.9.0
#= require_self

window.freezeTime = (string)->
  time = moment(string).valueOf()
  window.clock = sinon.useFakeTimers(time)
  # must manually clock.tick from extern so ember loop runs
