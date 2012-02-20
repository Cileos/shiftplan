# steps where the user sees things


Then /^I should (see|not see) (?:flash )?(flash|info|alert) "([^"]*)"$/ do |see_or_not, severity, message|
  if see_or_not =~ /not/
    step %Q{I should #{see_or_not} "#{message}"}
  else
    step %Q{I should #{see_or_not} "#{message}" within ".flash.alert.alert-#{severity}"}
  end
end

Then /^the page should be completely translated$/ do
  missing = "span.translation_missing"
  if page.has_css?(missing)
    page.all(:css, missing).each do |miss|
      message = "missing translation: #{miss['title']}"
      STDERR.puts message
      Rails.logger.debug message
    end
    page.should have_no_css('span.translation_missing')
  end
end

Then /^I should see a list of the following (.+):$/ do |plural, expected|
  selectors = expected.column_names.map(&:underscore).map {|s| ".#{s}" }
  actual = find("ul.#{plural}").all('li').map do |li| 
    selectors.map do |column| 
      li.find(column).try(:text).try(:strip)
    end
  end
  actual.unshift expected.column_names
  expected.diff! actual
end

Then /^the page should be titled "([^"]*)"$/ do |title|
  step %Q~I should see "#{title}" within "html head title"~
end

Then /^I (should|should not) be authorized to access the page$/ do |or_not|
  message = "Sie sind nicht berechtigt, auf diese Seite zuzugreifen."
  if or_not.include?('not')
    step %Q~I should see flash alert "#{message}"~
  else
    step %Q~I should not see flash "#{message}"~
  end
end

Then /^I (should|should not) see link #{capture_quoted}$/ do |or_not, link|
  if or_not.include?('not')
    page.should have_no_css('a', :text => link)
  else
    page.should have_css('a', :text => link)
  end
end
