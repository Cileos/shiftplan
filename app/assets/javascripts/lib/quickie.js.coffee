# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
exp               = {}
exp.hour          = /2[0-4]|1[0-9]|0[0-9]|[0-9]/
exp.minute        = /[0-5][0-9]|[0-9]/
exp.time          = XRegExp.build '(?x)^{{hour}}(:{{minute}})?$', exp
exp.hour_range    = XRegExp.build '(?x)^ (?<start_time>{{time}})-(?<end_time>{{time}}) $', exp
exp.team_name     = XRegExp.build '(?x)^ \\p{Letter} [\\p{Letter}\\d ]+?$'
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
  return if time.length == 0
  time = "0#{parseInt time, 10}" if time < 10
  if time.length > 2
    time
  else
    "#{time}:00"

fields = ['start_time', 'end_time', 'hour_range', 'team_name', 'team_shortcut', 'space_before_team']

class Quickie
  @parse: (string) ->
    quickie = new Quickie()
    if quickie.parse(string)
      quickie
    else
      null

  parse: (string) ->
    @clear()
    @parsed = XRegExp.exec string, exp.quickie
    if @parsed?
      for field in fields
        this[field] = @parsed[field]
      @verbose_start_time = addZeroes @parsed.start_time
      @verbose_end_time = addZeroes @parsed.end_time
      @parsed

  clear: ->
    for field in fields
      this[field] = null

  isValid: ->
    @start_time? and @end_time? and @start_time.length > 0 and @end_time.length > 0

  toString: ->
    q = ''
    q += removeZeroes(@start_time) if @start_time?
    q+='-'
    q += removeZeroes(@end_time) if @end_time?
    q+= " #{@team_name}" if @team_name? and @team_name.length > 0
    q+= " [#{@team_shortcut}]" if @team_shortcut? and @team_shortcut.length > 0
    q

window.Quickie = Quickie
