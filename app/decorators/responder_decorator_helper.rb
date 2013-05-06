module ResponderDecoratorHelper

  def respond(resource, action=:update)
    if resource.errors.empty?
      case action
      when :update
        respond_for_update(resource)
      when :destroy
        respond_for_destroy(resource)
      when :create
        respond_for_create(resource)
      else
        respond_normally(resource)
      end
      remove_modal
      respond_specially(resource)
    else
      prepend_errors_for(resource)
    end
  end

  # OPTIMIZE extract Overnightable-specific code
  def respond_for_update(resource)
    update_cell_for(resource.with_previous_changes_undone)
    if resource.next_day
      update_cell_for(resource.next_day.with_previous_changes_undone)
    end
    respond_normally(resource)
  end

  def respond_for_create(resource)
    respond_normally(resource)
  end

  def respond_for_destroy(resource)
    respond_normally(resource)
  end

  def respond_normally(resource)
    update_cell_for(resource)
    if resource.next_day
      update_cell_for(resource.next_day)
    end
    resource.repetitions.each do |r|
      respond_normally(r)
    end
  end

  def respond_specially(resource=nil)
    # do special stuff here
  end
end
