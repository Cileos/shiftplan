When /^I click on #{capture_cell}$/ do |cell|
  page.execute_script <<-EOJS
    $("#{selector_for(cell)}").click()
  EOJS
end

When /^I click on the #{capture_quoted} column$/ do |column_name|
  column = column_index_for(column_name)
  page.execute_script <<-EOJS
    $("tbody tr:first td:nth-child(#{column +1})").click()
  EOJS
end

When /^I click on the #{capture_quoted} row$/ do |row_name|
  row = row_index_for(row_name)
  page.execute_script <<-EOJS
    $("tbody tr:nth-child(#{row +1}) td:last").click()
  EOJS
end

When /^I click on (?:the )?scheduling #{capture_quoted}$/ do |quickie|
  scheduling = page.find(".scheduling", text: quickie)
  begin
    scheduling.click()
  rescue Selenium::WebDriver::Error::UnknownError => e # page was maybe still moving, could not hit element
    sleep 0.5
    scheduling.click() # try again once
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

Then /^I should see the following calendar:$/ do |expected|
  calendar = find(selector_for('the calendar'))
  actual = calendar.all("thead:first tr, tbody tr").map do |tr|
    tr.all('th, td').map do |cell|
      extract_text_from_cell(cell) || ''
    end
  end
  expected.diff! actual
end

Then /^I should see the following time bars:$/ do |raw|
  team_name = nil

  with_scope 'the calendar' do
    raw.lines.each do |line|
      if line =~ /^\s*#{capture_quoted}/
        team_name = $1
      end

      row = row_index_for(team_name)
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

Then /^I should see the following WAZ:$/ do |expected|
  calendar = find(selector_for('the calendar'))
  actual = calendar.all("tbody tr").map do |tr|
    tr.all('th:first span.employee_name, th:first .wwt_diff .badge').map(&:text)
  end
  expected.diff! actual
end

Then /^the employee #{capture_quoted} should have a (yellow|green|red|grey) hours\/waz value of "(\d+ \/ \d+|\d+)"$/ do |employee_name, color, text|
  color_class_mapping = {
    'yellow' => 'badge-warning',
    'green'  => 'badge-success',
    'red'    => 'badge-important',
    'grey'   => 'badge-normal'
  }

  classes = [ 'badge', color_class_mapping[color]].compact
  with_scope 'the calendar' do
    row = row_index_for employee_name
    within "tbody tr:nth-child(#{row+1}) th" do
      badge = ".wwt_diff .#{classes.join('.')}"
      page.should have_css(badge)
      page.first(badge).text.should == text
    end
  end
end

