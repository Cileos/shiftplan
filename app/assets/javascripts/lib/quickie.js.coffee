# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
exp               = {}
exp.hour          = /2[0-4]|1[0-9]|0[0-9]|[0-9]/
exp.minute        = /[0-5][0-9]|[0-9]/
exp.hour_range    = XRegExp.build '(?x)^ (?<start_hour>{{hour}})(:(?<start_minute>{{minute}}))?-(?<end_hour>{{hour}})(:(?<end_minute>{{minute}}))? $', exp
exp.team_name     = XRegExp.build '(?x)^ \\p{Letter} [\\p{Letter} ]+?$'
exp.team_shortcut = XRegExp.build '(?x)^ \\p{Letter}+ $'
exp.team_shortcut_in_brackets = XRegExp.build '(?x)^ \\[ ({{team_shortcut}}) \\] $', exp
exp.quickie       = XRegExp.build '(?x)^ \\s* ({{hour_range}}) ? (?<space_before_team>\\s*) ({{team_name}}) ? \\s* {{team_shortcut_in_brackets}} ? $', exp

twoDigi = (n) -> if "#{n}".length is 1 then "0#{n}" else n

class Quickie
  @parse: (string) ->
    XRegExp.exec string, exp.quickie
  # warning: toString is not an method on the parsed
  toString: ->
    q = ''
    if @start_minute? and @start_minute.length > 0
      q += "#{@start_hour}:#{twoDigi @start_minute}"
    else
      q += "#{@start_hour}"
    q+='-'
    if @end_minute? and @end_minute.length > 0
      q += "#{@end_hour}:#{twoDigi @end_minute}"
    else
      q += "#{@end_hour}"
    q+= " #{@team_name}"
    q

window.Quickie = Quickie
