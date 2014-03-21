Clockwork.UnavailabilitiesController = Ember.ArrayController.extend
  daysGroupedByWeek: ( ->
    [
      [1,2,3],
      [4,5,6],
      [7,8,9],
    ]
  ).property('days')

