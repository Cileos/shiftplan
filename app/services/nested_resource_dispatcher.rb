class NestedResourceDispatcher

  # returns an array to be used in link_to and other helpers containing the full-defined nesting for the given resource
  def resources_for(resource, *extra)
    case resource
    when Comment
      resources_for(resource.commentable.blog) + [ resource.commentable, resource]
    when Post
      resources_for(resource.blog) + [resource]
    when Blog, Team, Plan, PlanTemplate
      resources_for(resource.organization) + [resource]
    when Organization
      [ resource.account, resource ]
    when Shift
      resources_for(resource.plan_template) + [resource]
    when Scheduling, AttachedDocument
      resources_for(resource.plan) + [resource]
    else
      raise ArgumentError, "cannot find nesting for #{resource.inspect}"
    end + extra
  end

end
