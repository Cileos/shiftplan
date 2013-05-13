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

class Quickie
  @parse: (string) ->
    parsed = XRegExp.exec string, exp.quickie
    parsed.toString = Quickie::toString if parsed?
    parsed
  # warning: toString is not an method on the parsed
  toString: ->
    q = ''
    q += removeZeroes(@start_time) if @start_time?
    q+='-'
    q += removeZeroes(@end_time) if @end_time?
    q+= " #{@team_name}"
    q

window.Quickie = Quickie
