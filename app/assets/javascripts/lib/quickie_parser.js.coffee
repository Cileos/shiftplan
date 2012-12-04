# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
expression = """
  (?<hour_range> (?:2[0-4]|1[0-9]|[0-9])-(?:2[0-4]|1[0-9]|[0-9]))
  \\s*
  (?<team_name> [\\p{Letter}] [\\p{Letter} ]+)
  \\s*
  \\[(?<team_shortcut> [\\p{Letter}]+)\\]
"""

QuickieParser =
  expression: XRegExp expression, 'x'
  parse: (quickie) ->
    XRegExp.exec quickie, @expression

window.QuickieParser = QuickieParser
