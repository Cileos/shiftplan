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

    when /^the (?:signin|sign in) page/
      new_user_session_path

    when /^the (?:signup|sign up) page/
      signup_path

    when /^the setup page$/
      setup_path

    when /^the change (email|password) page$/
      send("change_#{$1}_path")

    when /^my profile page$/
      profile_path

    when /^the profile page of #{capture_model}$/
      case model = model!($1)
      when Employee
        edit_profile_employee_path(model)
      end

    when /^the profile page of my employees$/
      profile_employees_path

    when /^the edit profile page$/
      edit_profile_path

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
      else
        raise ArgumentError, "cannot find page for #{$1}, please add it in #{__FILE__}:#{__LINE__}"
      end

    when /^the posts page of #{capture_model}$/
      blog = model!($1)
      account_organization_blog_posts_path(blog.organization.account, blog.organization, blog)

    when /^the (teams in week|hours in week|teams in day|employees in week) page (?:of|for) #{capture_model}(?: for #{capture_fields})?$/
      scope, model, params = $1, model!($2), parse_fields($3).symbolize_keys
      raise ArgumentError, "only plans and plan templates can be scoped as #{scope}" unless model.is_a?(Plan) || model.is_a?(PlanTemplate)
      organization = model.organization
      send "account_organization_#{model.class.name.underscore}_#{scope.strip.gsub(/\s+/,'_')}_path", organization.account, organization, model, params

    when /^(?:my|the) dashboard$/
      dashboard_path

    when /^accounts page$/
      accounts_path

    when /^the report page of #{capture_model}$/
      m = model!($1)
      case m
      when Account
        new_account_report_path(m)
      when Organization
        new_account_organization_report_path(m.account, m)
      end

    when /^my availability page for #{capture_fields}$/
      now = Time.current
      fields = parse_fields($1).symbolize_keys.reverse_merge(
        year: now.year,
        month: now.month
      )

      availability_path anchor: "/unas/me/#{fields[:year]}/#{fields[:month]}"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
      #
    when/^the (employees|plan templates|qualifications) page for #{capture_model}$/
      model = model($2)
      if model.is_a?(Organization)
        send "account_organization_#{$1.gsub(' ', '_')}_path", model.account, model
      elsif model.is_a?(Account)
        send "account_#{$1.gsub(' ', '_')}_path", model
      else
        raise ArgumentError, "only paths scoped to organizations defined so far. please add more paths in #{__FILE__}:#{__LINE__}"
      end

    when/^the new ([a-z ]+) page for #{capture_model}$/
      model = model($2)
      if model.is_a?(Organization)
        send "new_account_organization_#{$1.gsub(' ', '_')}_path", model.account, model
      elsif model.is_a?(Account)
        send "new_account_#{$1.gsub(' ', '_')}_path", model
      end

    when /^the adopt employees page for #{capture_model}$/
      org = model!($1)
      adopt_account_organization_employees_path(org.account, org)

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

  # Put this around compound steps to make sure they do not leave the page
  # (or at least come back to it)
  def with_invariant_page_path
    start = URI.parse(current_url).path
    yield
    URI.parse(current_url).path.should eql(start), 'page was changed'
  end

end

World(NavigationHelpers)
