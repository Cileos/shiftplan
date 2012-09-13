# steps where the user sees things


Then /^I should (see|not see) (?:an? )?(?:flash )?(flash|info|alert|notice) "([^"]*)"$/ do |see_or_not, severity, message|
  if see_or_not =~ /not/
    step %Q{I should #{see_or_not} "#{message}"}
  else
    step %Q{I should #{see_or_not} "#{message}" within ".flash.#{severity}"}
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
  actual = first("ul.#{plural}").all('li').map do |li|
    selectors.map do |column|
      li.first(column).try(:text).try(:strip) || ''
    end
  end
  actual.unshift expected.column_names
  expected.diff! actual
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

Then /^I should see the following table of (.+):$/ do |plural, expected|
  # table is a Cucumber::Ast::Table
  actual = find("table##{plural}").all('tr').map do |tr|
    # tr.all('th,td').map(&:text).map(&:strip)
    tr.all('th, td').map do |cell|
    if cell.tag_name == 'th' or cell.all('*').empty? # a text-only cell ader
      cell.text
    else # remove the text of all included buttons and links, they gonna be clicked anyway
      text = cell.text
      cell.all('a.btn,a.comments,button').each do |e|
        text = text.sub(e.text, '')
      end
      text
    end.strip.squeeze(' ')
    end
  end
  expected.diff! actual
end

Then /^the page should be titled "([^"]*)"$/ do |title|
  step %Q~I should see "#{title}" within "html head title"~
end

Then /^I (should|should not) be authorized to access the page$/ do |or_not|
  message = "Sie sind nicht berechtigt, auf diese Seite zuzugreifen."
  if or_not.include?('not')
    step %~I should be on the homepage~
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

Then /^the team color should be "([^"]*)"$/ do |color|
  selector = '.pibble.team-color'
  page.should have_css(selector)
  first(selector)['style'].should include("background-color: #{color}")
end

Then /^I (should|should not) see a delete button$/ do |should_or_should_not|
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

Then /^I should see a (tiny|thumb) (gravatar|default gravatar)$/ do |version, gravatar_or_default_gravatar|
  image_tag = page.find("img.avatar.#{version}")
  url, params = image_tag['src'].split('?')

  url.should match(%r~https://secure.gravatar.com/avatar/[0-9abcdef]{32}\.png~)

  size = AvatarUploader.const_get("#{version.to_s.camelize}Size")
  if gravatar_or_default_gravatar == 'gravatar'
    params.should == "d=mm&r=PG&s=#{size}"
  else
    params.should == "d=mm&forcedefault=y&r=PG&s=#{size}"
  end
end
