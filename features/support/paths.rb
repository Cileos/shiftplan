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

    when /the (?:signin|sign in) page/
      new_user_session_path

    when /the (?:signup|sign up) page/
      new_user_registration_path

    when /^the (email|password) page of #{capture_model}$/
      email_or_password = $1
      send("user_#{email_or_password}_path")

    when /^the profile page of #{capture_model}$/
      case model = model!($1)
      when Employee
        edit_profile_employee_path(model)
      end

    when /^the profile page of my employees$/
      profile_employees_path

    # the page for teams of the organization "Reactor"
    when /^the page for (\w+) of #{capture_model}$/
      sub = $1
      case model = model!($2)
      when Organization
        polymorphic_path [model.account, model, sub]
      end

    when /^the plans page of #{capture_model}$/
      organization = model!($1)
      account_organization_plans_path(organization.account, organization)

    when /^the page (?:of|for) #{capture_model}(?: for #{capture_fields})?$/
      params = parse_fields($2).symbolize_keys
      case model = model!($1)
      when Post
        organization = model.organization
        account_organization_blog_post_path(organization.account, organization, model.blog, model)
      when Plan
        organization = model.organization
        account_organization_plan_path(organization.account, organization, model, params)
      when Organization
        account_organization_path(model.account, model)
      when User
        user_path
      when Account
        account_path(model)
      else
        raise ArgumentError, "cannot find page for #{$1}, please add it in #{__FILE__}:#{__LINE__}"
      end

    when /^the posts page of #{capture_model}$/
      blog = model!($1)
      account_organization_blog_posts_path(blog.organization.account, blog.organization, blog)

    when /^the (teams in week|hours in week|teams in day|employees in week) page (?:of|for) #{capture_model}(?: for #{capture_fields})?$/
      scope, model, params = $1, model!($2), parse_fields($3).symbolize_keys
      raise ArgumentError, "only plans can be scoped as #{scope}" unless model.is_a?(Plan)
      organization = model.organization
      send "account_organization_plan_#{scope.strip.gsub(/\s+/,'_')}_path", organization.account, organization, model, params

    when /^(?:my|the) dashboard$/
      dashboard_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /^the employees page for #{capture_model}$/
      org = model!($1)
      account_organization_employees_path(org.account, org)

    when /^the new employee page for #{capture_model}$/
      org = model!($1)
      new_account_organization_employee_path(org.account, org)

    when /^the email change confirmation page$/
      accept_email_change_path

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
