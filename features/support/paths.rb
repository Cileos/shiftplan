module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the start page/
      root_path
    when /the plans index page/
      plans_path
    when /the plan show page/
      plan_path(Plan.first)
    when /the employees index page/
      employees_path
    when /the workplaces index page/
      workplaces_path
    when /the qualifications index page/
      qualifications_path
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
