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

  def respond_for_update(resource)
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
    respond_for_next_day(resource)
    respond_for_repetitions(resource)
  end

  def respond_for_next_day(resource)
    if resource.next_day
      update_cell_for(resource.next_day)
    end
  end

  def respond_for_repetitions(resource)
    if resource.respond_to?(:repetitions)
      resource.repetitions.each do |r|
        respond_normally(r)
      end
    end
  end

  def respond_specially(resource=nil)
    # do special stuff here
  end
end
