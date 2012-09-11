Shiftplan.EditDoable = Ember.View.extend
  templateName: 'doable/edit'
  save: (e) ->
    doable = @get('content')
    Shiftplan.store.commit()

