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
        edit_employee_path(model!($1))
      end

    when /^the page (?:of|for) #{capture_model}(?: for #{capture_fields})?$/
      params = parse_fields($2).symbolize_keys
      case model = model!($1)
      when Plan
        # TODO we may have to scope this under its organization laater
        if params[:week]
          if params[:year]
            plan_year_week_path(model, params[:year], params[:week])
          else
            plan_week_path(model, params[:week])
          end
        else
          plan_path(model, params)
        end
      when Employee
        employee_path(model)
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

    when /^employees page$/
      employees_page

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
