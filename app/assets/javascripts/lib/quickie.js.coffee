# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
exp               = {}
exp.hour          = /2[0-4]|1[0-9]|0[0-9]|[0-9]/
exp.minute        = /[0-5][0-9]|[0-9]/
exp.hour_range    = XRegExp.build '(?x)^ (?<start_time>{{hour}}(:{{minute}})?)-(?<end_time>{{hour}}(:{{minute}})?) $', exp
exp.team_name     = XRegExp.build '(?x)^ \\p{Letter} [\\p{Letter} ]+?$'
exp.team_shortcut = XRegExp.build '(?x)^ \\p{Letter}+ $'
exp.team_shortcut_in_brackets = XRegExp.build '(?x)^ \\[ ({{team_shortcut}}) \\] $', exp
exp.quickie       = XRegExp.build '(?x)^ \\s* ({{hour_range}}) ? (?<space_before_team>\\s*) ({{team_name}}) ? \\s* {{team_shortcut_in_brackets}} ? $', exp

removeZeroes = (time) ->
  if time.slice(-2) is '00'
    parseInt time.slice(0,2), 10 # remove leading zeroes for full hours
  else
    time

addZeroes = (time) ->
  return unless time?
  time = "0#{time}" if time < 10
  if time.length > 2
    time
  else
    "#{time}:00"


class Quickie
  @parse: (string) ->
    parsed = XRegExp.exec string, exp.quickie
    if parsed?
      parsed.toString = Quickie::toString
      parsed.isValid = Quickie::isValid
      parsed.verbose_start_time = addZeroes parsed.start_time
      parsed.verbose_end_time = addZeroes parsed.end_time
    parsed

  isValid: ->
    @start_time? and @end_time?

  toString: ->
    q = ''
    q += removeZeroes(@start_time) if @start_time?
    q+='-'
    q += removeZeroes(@end_time) if @end_time?
    q+= " #{@team_name}" if @team_name?
    q

window.Quickie = Quickie
