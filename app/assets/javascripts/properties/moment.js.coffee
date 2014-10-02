# provides DS.attr('moment') as moment() timestamp in the server's timezone
Clockwork.MomentTransform = DS.Transform.extend
  serialize: (value)->
    if value then value.toJSON() else null
  deserialize: (value)->
    parsed = moment(value).clone().tz( timeZoneName() )
    if parsed.isValid() then parsed else null

