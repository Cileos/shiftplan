# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
exp               = {}
exp.hour          = /2[0-4]|1[0-9]|[0-9]/
exp.hour_range    = XRegExp.build '(?x)^ (?<start_hour>{{hour}})-(?<end_hour>{{hour}}) $', exp
exp.team_name     = XRegExp.build '(?x)^ \\p{Letter} [\\p{Letter} ]+?$'
exp.team_shortcut = XRegExp.build '(?x)^ \\p{Letter}+ $'
exp.team_shortcut_in_brackets = XRegExp.build '(?x)^ \\[ ({{team_shortcut}}) \\] $', exp
exp.quickie       = XRegExp.build '(?x)^ \\s* ({{hour_range}}) ? \\s* ({{team_name}}) ? \\s* {{team_shortcut_in_brackets}} ? $', exp

class Quickie
  @parse: (string) ->
    XRegExp.exec string, exp.quickie

window.Quickie = Quickie
