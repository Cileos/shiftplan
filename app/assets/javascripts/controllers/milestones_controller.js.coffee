Clockwork.MilestonesController = Ember.ArrayController.extend
  needs: ['employees']
  filteredContent: Ember.computed( ->
    @get('content').filterProperty('isNew', false)
  ).property('content.@each.isNew')
