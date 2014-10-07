When /^I click on #{capture_cell}$/ do |cell|
  find(*selector_for(cell)).click
end

When /^I click on (a .*)$/ do |name|
  find(*selector_for(name)).click
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
  shift_or_scheduling = page.first(selector, text: quickie)
  begin
    shift_or_scheduling.click()
    wait_for_the_page_to_be_loaded
  rescue Selenium::WebDriver::Error::UnknownError => e # page was maybe still moving, could not hit element
    sleep 0.5
    shift_or_scheduling.click() # try again once
  end
end

Then /^the #{capture_cell} should be (focus)$/ do |cell, predicate|
  page.find(*selector_for(cell))[:class].split.should include(predicate)
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
  some_time_passes
  expected.diff! the_calendar.parsed
end

# Then I should see the following partial calendar:
#        | Teams | Di | Mi | Do | Fr | Sa | So |
#        | C     |    |    |    |    |    |    |
#        | B     |    |    |    |    |    |    |
#
# It will not fail if there is an A-team at the end or the Monday is even important
Then /^I should see the following partial calendar:$/ do |expected|
  some_time_passes
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

When /^(?:I|they) schedule (\w+ |)#{capture_quoted}$/ do |kind, quickie_string|
  kind = 'scheduling' if kind.blank?
  kind = kind.strip
  quickie = Quickie.parse(quickie_string)

  holder = Struct.new(:start_time, :end_time, :team_name).new
  quickie.fill(holder)

  step %Q~I select "#{holder.team_name}" from the "Team" single-select box~ if holder.team_name.present?
  %w(start end).each do |pos|
    name = "#{kind}_#{pos}_time"
    attr = "#{pos}_time"
    val = holder.public_send(attr)
    if val.present?
      find_field(name).send_string_of_keys 'arrow_left,arrow_left,arrow_left,arrow_left'
      fill_in(name, with: val)
    end
  end
end

# TODO same as "I fill in the empty" ?
When /^I schedule #{capture_quoted} on #{capture_quoted} for #{capture_quoted}$/ do |employee, day, quickie|
  step %Q~I click on cell "#{day}"/"#{employee}"~
  within_modal_box do
    step %Q~I schedule "#{quickie}"~
    click_button "Anlegen"
  end
end

# Assuming we just clicked on a scheduling in one of the views, a modal box should open..
Then /^I reschedule #{capture_quoted} and select #{capture_quoted} as #{capture_quoted}$/ do |quickie, employee, employee_field|
  within_modal_box do
    step %Q~I schedule "#{quickie}"~
    select employee, from: employee_field
    click_button "Speichern"
  end
end

Then /^I reschedule #{capture_quoted} and select #{capture_quoted} as #{capture_quoted} in the single-select box$/ do |quickie, employee, employee_field|
  within_modal_box do
    step %Q~I schedule "#{quickie}"~
    step %Q~I select "#{employee}" from the "#{employee_field}" single-select box~
    click_button "Speichern"
  end
end

# These steps brake with jquery-ui 5.0
When(/^I drag #{capture_quoted} and drop it onto #{capture_cell}$/) do |handle, cell_name|
  cell = page.find *selector_for(cell_name)
  cell.should_not be_nil, "could not find cell #{cell_name}"
  execute_script %q~$('.scheduling').trigger('mousemove')~
  ele = page.find('li.ui-draggable', text: handle)
  ele.should_not be_nil, "could not find draggable #{handle}"
  # must setup lazy initialized draggables/droppables
  ele.drag_to(cell)
  some_time_passes
end

When(/^I drag #{capture_quoted} and drop it onto #{capture_column}$/) do |handle, column_name|
  column = page.find *selector_for(column_name)
  column.should_not be_nil, "could not find column #{column_name}"
  # must setup lazy initialized draggables/droppables
  execute_script %q~$('.scheduling').trigger('mousemove')~
  ele = page.find('div.ui-draggable', text: handle)
  ele.should_not be_nil, "could not find draggable #{handle}"
  ele.drag_to(column)
  some_time_passes
end
