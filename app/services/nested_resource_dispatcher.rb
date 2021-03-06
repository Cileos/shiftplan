class NestedResourceDispatcher

  def initialize(view)
    @view = view
  end

  # returns an array to be used in form_for containing the full-defined nesting for the given resource.
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
    when Milestone, Task
      if d = resource.due_at
        return @view.account_organization_plan_employees_in_week_path(*resources_for(resource.plan), cwyear: d.cwyear, week: d.cweek)
      else
        resources_for(resource.plan)
      end
    else
      raise ArgumentError, "cannot find nesting for #{resource.inspect}"
    end + extra
  end

  # @returns components usable with polymorphic_path(*this) to link directly to the given resource
  #
  # Note:  May be different from #resources_for for resources without a designated 'show' page.
  def show_resources_for(resource, *extras_and_options)
    options = extras_and_options.extract_options!
    extra = extras_and_options.reject(&:nil?).join('/')
    extra = '/' + extra unless extra.blank?

    case resource
    when Scheduling, SchedulingDecorator
      mode = options.fetch(:mode) { :employees_in_week }
      [ resources_for(resource.plan, mode),
        {
          cwyear: resource.cwyear,
          week: resource.week,
          anchor: "/scheduling/#{resource.id}#{extra}"
        }
      ]
    end
  end

end
