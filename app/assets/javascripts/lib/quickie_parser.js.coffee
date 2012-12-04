# WARNING: always keep behaviour in sync with Ruby part in lib/quickie.treetop
QuickieParser =
  expressions:
    hour_range: /((?:2[0-4]|1[0-9]|[0-9])-(?:2[0-4]|1[0-9]|[0-9]))/
  parse: (quickie) ->
    parsed = {}

    if m = quickie.match(@expressions.hour_range)
      parsed.hour_range = m[1]

    parsed


window.QuickieParser = QuickieParser
