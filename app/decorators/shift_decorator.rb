class ShiftDecorator < RecordDecorator
  decorates :shift

  def respond(resource, action=:update)
    if resource.errors.empty?
      if action == :update
        respond_for_update(resource)
      else
        respond_for_create(resource)
      end
      remove_modal
    else
      prepend_errors_for(resource)
    end
  end

  private

  def respond_for_update(resource)
    # TODO: implemente
  end

  def respond_for_create(resource)
    # TODO: implemente
  end
end
