module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the (?:home|landing)\s?page$/
      '/'

    when 'the signin page'
      new_user_session_path

    when /^the edit page (?:of|for) #{capture_model}$/
      case model = model!($1)
      when Employee
        edit_employee_path(model)
      end

    when /^the profile page of #{capture_model}$/
      case model = model!($1)
      when Employee
        edit_profile_employee_path(model)
      end

    when /^the profile page of my employees$/
      profile_employees_path

    when /^the page (?:of|for) #{capture_model}(?: for #{capture_fields})?$/
      params = parse_fields($2).symbolize_keys
      case model = model!($1)
      when Post
        organization_blog_post_path(model.organization, model.blog, model)
      when Plan
        if params[:week]
          if params[:year]
            organization_plan_year_week_path(model.organization, model, params[:year], params[:week])
          else
            organization_plan_week_path(model.organization, model, params[:week])
          end
        else
          organization_plan_path(model.organization, model, params)
        end
      when Employee
        employee_path(model)
      when Organization
        organization_path(model)
      else
        raise ArgumentError, "cannot find page for #{$1}, please add it in #{__FILE__}:#{__LINE__}"
      end

    when /^(?:my|the) dashboard$/
      dashboard_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /^the employees page for #{capture_model}$/
      org = model!($1)
      organization_employees_path(org)

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
