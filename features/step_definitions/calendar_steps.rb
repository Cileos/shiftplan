When /^I click on #{capture_cell}$/ do |cell|
  page.execute_script <<-EOJS
    $("#{selector_for(cell)}").click()
  EOJS
end

When /^I click on (a .*)$/ do |name|
  page.execute_script <<-EOJS
    $("#{selector_for(name)}").click()
  EOJS
end

When /^I click on the #{capture_quoted} column$/ do |column_name|
  column = the_calendar.column_index_for(column_name)
  page.execute_script <<-EOJS
    $("tbody tr:first td:nth-child(#{column +1})").click()
  EOJS
end

When /^I click on the #{capture_quoted} row$/ do |row_name|
  row = the_calendar.row_index_for(row_name)
  page.execute_script <<-EOJS
    $("tbody tr:nth-child(#{row +1}) td:last").click()
  EOJS
end

When /^I click on (?:the )?(early|late|) ?(shift|scheduling) #{capture_quoted}$/ do |early_or_late, shift_or_scheduling, quickie|
  selector = ".#{shift_or_scheduling}"
  selector << ".#{early_or_late}" if early_or_late.present?
  shift_or_scheduling = page.find(selector, text: quickie)
  begin
    shift_or_scheduling.click()
  rescue Selenium::WebDriver::Error::UnknownError => e # page was maybe still moving, could not hit element
    sleep 0.5
    shift_or_scheduling.click() # try again once
  end
end

Then /^the #{capture_cell} should be (focus)$/ do |cell, predicate|
  page.find(selector_for(cell))[:class].split.should include(predicate)
end

Then /^the scheduling #{capture_quoted} should be (focus)$/ do |quickie, predicate|
  page.find("li", text: quickie)[:class].split.should include(predicate)
end

Then /^I should see a calendar (?:titled|captioned) #{capture_quoted}$/ do |caption|
  step %Q~I should see "#{caption}" within the calendar caption~
end

# Then I should see the following calendar:
#        | Teams | Mo | Di | Mi | Do | Fr | Sa | So |
#        | C     |    |    |    |    |    |    |    |
#        | B     |    |    |    |    |    |    |    |
#
# It will fail if there is an A-team or Caturday hidden somewhere
Then /^I should see the following calendar:$/ do |expected|
  expected.diff! the_calendar.parsed
end

# Then I should see the following partial calendar:
#        | Teams | Di | Mi | Do | Fr | Sa | So |
#        | C     |    |    |    |    |    |    |
#        | B     |    |    |    |    |    |    |
#
# It will not fail if there is an A-team at the end or the Monday is even important
Then /^I should see the following partial calendar:$/ do |expected|
  expected.diff! the_calendar.parsed, surplus_row: false, surplus_col: false
end

Then /^I should see the following time bars:$/ do |raw|
  team_name = nil

  with_scope 'the calendar' do
    raw.lines.each do |line|
      if line =~ /^\s*#{capture_quoted}/
        team_name = $1
      end

      row = the_calendar.row_index_for(team_name)
      expected_bars = line.scan(/\|[^|]+\|/)

      expected_bars.each do |bar|     # |9-"Homer S"-17|
        if team_name.blank?
          raise ArgumentError, "no team name found yet"
        end
        if bar =~ /^\|(\d+)-#{capture_quoted}-(\d+)\|$/
          start_hour, employee, end_hour = $1.to_i, $2, $3.to_i
          selector = %Q~tbody tr:nth-child(#{row+1}) td.bars div.scheduling[data-start="#{start_hour}"][data-length="#{end_hour - start_hour}"]~
          page.should have_css(selector, text: employee)
        else
          raise ArgumentError, "bad time bar given: #{bar.inspect}"
        end
      end

      if expected_bars.empty?
        page.should have_no_css( %Q~tbody tr:nth-child(#{row+1}) td.bars div.scheduling~ )
      end
    end
  end
end

Then /^I should see the following (employee|team) WAZ:$/ do |kind, expected|
  case kind
  when 'employee'
    expected.diff! the_calendar.employees_with_batches, :surplus_row => false
  when 'team'
    expected.diff! the_calendar.teams_with_batches, :surplus_row => false
  end
end

Then /^the employee #{capture_quoted} should have a (yellow|green|red|grey) hours\/waz value of "(\d+.? \/ \d+|\d+)"$/ do |employee_name, color, text|
  color_class_mapping = {
    'yellow' => 'badge-warning',
    'green'  => 'badge-success',
    'red'    => 'badge-important',
    'grey'   => 'badge-normal'
  }

  classes = [ 'badge', color_class_mapping[color]].compact
  row = the_calendar.row_index_for employee_name
  with_scope 'the calendar' do
    within "tbody tr:nth-child(#{row+1}) th" do
      badge = ".wwt_diff .#{classes.join('.')}"
      page.should have_css(badge)
      page.first(badge).text.should == text
    end
  end
end

# faster lookup
When /^I assume the calendar will not change$/ do
  the_calendar.cache!
  # calendar will be cleared after each scenario
end
