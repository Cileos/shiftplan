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
    when /the workplaces index page/
      workplaces_path
    when /the employees index page/
      employees_path
    when /the allocations listing for week (\d{1,2}) in year (\d{4})/
      allocations_by_week_path(:week => $1, :year => $2)
    when /the allocations listing for ?(\d{1,2})? (.*) (\d{4})/
      year, month, day = Date._parse($&).values_at(:year, :mon, :mday)
      allocations_by_date_path(:year => year, :month => month, :day => day)
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
