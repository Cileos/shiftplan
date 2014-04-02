Clockwork.CheckboxSelectComponent = Ember.Component.extend
  # The property to be used as label
  labelPath: null

  # The model whiches hasmany you want to edit
  model: null

  # The has many property from the model
  propertyPath: null

  # All possible elements, to be selected
  elements: null
  elementsOfProperty: (->
    @get "model." + @get("propertyPath")
  ).property()

Clockwork.CheckboxItemController = Ember.ObjectController.extend
  selected: (->
    element = @get("content")
    children = @get("parentController.elementsOfProperty")
    children.contains element
  ).property()
  label: (->
    @get "model." + @get("parentController.labelPath")
  ).property()
  selectedChanged: (->
    element = @get("content")
    children = @get("parentController.elementsOfProperty")
    if @get("selected")
      children.pushObject element
    else
      children.removeObject element
    return
  ).observes("selected")

  serializeHasMany
