# steps where the user sees things


Then /^I should (see|not see) message "([^"]*)"$/ do |see_or_not, message|
  if see_or_not =~ /not/
    Then %Q{I should #{see_or_not} "#{message}"}
  else
    Then %Q{I should #{see_or_not} "#{message}" within ".flash"}
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
