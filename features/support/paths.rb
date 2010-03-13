module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    # when /^the start page$/
    #   root_path
    # when /the plans index page$/
    #   plans_path
    # when /^the plan show page$/
    #   plan_path(Plan.first)
    # when /^the employees index page$/
    #   employees_path
    # when /^the workplaces index page$/
    #   workplaces_path
    # when /^the qualifications index page$/
    #   qualifications_path
    # when /^the default statuses index page$/
    #   default_statuses_path
    # when /^the statuses index page$/
    #   statuses_path
    # when /^the tags index page$/
    #   tags_path
    when /^the start page$/
      '/'
    when /^the plans index page$/
      '/plans'
    when /^the plan show page$/
      "/plans/#{Plan.first.id}"
    when /^the employees index page$/
      '/employees'
    when /^the workplaces index page$/
      '/workplaces'
    when /^the qualifications index page$/
      '/qualifications'
    when /^the default statuses index page$/
      '/default_statuses'
    when /^the statuses index page$/
      '/statuses'
    when /^the statuses index page for week (\d{1,2}) of year (\d{4})$/
      "/statuses/#{$2}/W#{$1}"
    when /^the statuses index page for "(.+)" for "(.+) (\d{4})"$/
      month = Date::MONTHNAMES.index($2)
      "/employees/#{Employee.find_by_name($1).id}/statuses?year=#{$3}&month=#{month}"
    when /^the tags index page$/
      '/tags'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def link_text_for(id)
    case id

    when /^add_/
      '[Click to add]'
    when /^edit_/
      'Edit'
    when /^delete_/
      'Delete'

    else
      raise "Can't find link text for #{id}"
    end
  end
end

World(NavigationHelpers)
