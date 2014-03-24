Clockwork.Unavailability = DS.Model.extend
  reason: DS.attr('string')
  startsAt: DS.attr('date')
  endsAt: DS.attr('date')
