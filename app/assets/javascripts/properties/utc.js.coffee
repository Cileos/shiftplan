# provides DS.attr('utc') as moment() object
Clockwork.UtcTransform = DS.Transform.extend
  serialize: (value)->
    if value then value.toJSON() else null
  deserialize: (value)->
    parsed = moment.utc(value)
    if parsed.isValid() then parsed else null
