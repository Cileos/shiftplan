# steps where the user sees things


Then /^I should (see|not see) (?:an? )?(?:flash )?(flash|info|alert|notice) "([^"]*)"$/ do |see_or_not, severity, message|
  step %Q{I wait for the spinner to disappear}
  if see_or_not =~ /not/
    page.should have_no_content(message)
  else
    page.should have_css(".flash.#{severity}", text: message)
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
  list_sel = "ul.#{plural}"
  page.should have_css(list_sel)
  actual = first(list_sel).all('li').map do |li|
    selectors.map do |column|
      li.first(column).try(:text).try(:strip).try(:lines).try(:first) || ''
    end
  end
  actual.unshift expected.column_names
  expected.diff! actual
end

Then /^I should see an empty (.+) list$/ do |list_name|
  list_selector = "ul.#{list_name}"
  page.should have_css(list_selector)
  page.first(list_selector).all('li').should be_empty
end

Then /^I should see the following list of links:$/ do |expected|
  expected.column_names.should == %w(link active)
  actual = all('ul li:has(a)').map do |li|
    [
      li.first('a').text.strip,
      (li[:class] || '').split.include?('active').to_s
    ]
  end
  actual.unshift expected.column_names
  expected.diff! actual
end

Then /^I should see the following items in (.* list):$/ do |list_name, expected|
  list = first( selector_for(list_name) )
  actual = list.all('li').map do |li|
    [ li.try(:text).try(:strip) || '' ]
  end
  expected.diff! actual
end

# %table#people
#   %tr
#     %td.name
#     %td.age
Then /^I should see the following table of (.+):$/ do |plural, expected|
  retrying_once Selenium::WebDriver::Error::WebDriverError do
    table = TableHelpers::Table.new(self, selector: "table##{plural}", row_selector: 'tr:not(.aggregation)', ignore: 'a.button,a.comments,button,.avatar')
    expected.diff! table.parsed
  end
end

Then /^I should see the following table for #{capture_model}:$/ do |ref, table|
  model = model!(ref)
  id = selector_for("the table for #{ref}").sub(/^table#/,'')
  step "I should see the following table of #{id}:", table
end


# The difference between this step and the previous is: THIS one can handle multiple values per cell properly, for example
# %table.overview
#   %tr
#     %td
#       %span.name Nina
#       .age 19
#
# Then I should see an overview table with the following rows
#   | name | age |
#   | Nina | 19  |
Then /^I should see an? (\w+) table with the following rows:$/ do |name, expected|
  selectors = expected.column_names.map {|s| ".#{s}" }
  actual = find("table.#{name}").all('tr').map do |tr|
    selectors.map do |column|
      tr.find(column).text.strip.gsub(/\s+/, ' ')
    end
  end
  actual.unshift expected.column_names
  expected.diff! actual
end

Then /^the page (should|should not) be titled "([^"]*)"$/ do |should_or_should_not, title|
  not_ignoring_hidden_elements do
    step %Q~I #{should_or_should_not} see "#{title}" within "html head title"~
  end
end

Then /^I (should|should not) be authorized to access the page$/ do |or_not|
  message = "Sie sind nicht berechtigt, auf diese Seite zuzugreifen."
  if or_not.include?('not')
    step %~I should be on the dashboard~
    step %Q~I should see flash alert "#{message}"~
  else
    step %Q~I should not see flash "#{message}"~
  end
end

Then /^I (should|should not) see (link|button) #{capture_quoted}$/ do |or_not, link_or_button, text|
  link_button_map = { 'link' => 'a', 'button' => 'button'}
  if or_not.include?('not')
    page.should have_no_css(link_button_map[link_or_button], :text => text)
  else
    page.should have_css(link_button_map[link_or_button], :text => text)
  end
end

Then /^the team color should be "([^"]*)"$/ do |color|
  selector = '.pibble.team-color'
  page.should have_css(selector)
  first(selector)['style'].should include("background-color: #{color}")
end

Then /^there (should|should not) be a delete button on the page$/ do |should_or_should_not|
  if should_or_should_not.include?('not')
    page.should have_no_css('input[name="_method"][value="delete"]')
  else
    page.should have_css('input[name="_method"][value="delete"]')
  end
end

Then /^I should see the avatar "([^"]*)"$/ do |file_name|
  image_tag = page.find("img.avatar")
  assert image_tag['src'].split('/').last.include?(file_name), "No image tag with src including '#{file_name}' found"
  path = [Rails.root, 'features', image_tag['src'].split('/features/')[1]].join('/')
  assert File.exists?(path), "File '#{path}' does not exist."
end

Then /^I should not see a field labeled #{capture_quoted}$/ do |label|
  page.should have_no_xpath( XPath::HTML.field(label) )
end

Then /^the notification hub should have (\d+) unseen notifications?$/ do |number|
  step %~I should see "#{number}" within the notifications count~
  not_ignoring_hidden_elements do
    step %~I should see "(#{number})" within the page title~
  end
  step %~the notification hub should have class "has_unseen"~
end

Then /^the notification hub should have no unseen notifications$/ do
  step %~the notification hub should not have class "has_unseen"~
  page.should have_css("a#notifications-count div.icon-bell_empty", text: '')
end

Then /^the notification hub (should|should not) have unread notifications$/ do |or_not|
  step %~the notification hub #{or_not} have class "has_unread"~
end

Then /^the notification hub (should|should not) have class #{capture_quoted}$/ do |or_not, css_class|
  if or_not.include?('not')
    page.should have_no_css("li#notification-hub.#{css_class}")
  else
    page.should have_css("li#notification-hub.#{css_class}")
  end
end

Then /^there (should|should not) be an ics export link on the page$/ do |should_or_should_not|
  if should_or_should_not.include?('not')
    page.should have_no_css('a#ics-export-link')
  else
    page.should have_css('a#ics-export-link')
  end
end
