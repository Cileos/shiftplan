When /^I pause|try pry|I pry|I debug$/ do
  STDERR.puts "Pausing..."
  if system(%Q~which zenity~)
    question = "Paused. Want to pry?"
    if system(%Q~zenity --question --text="#{question}"~)
      binding.pry
    end
  else
    binding.pry
  end
end

When /^nothing$/ do
  # for scenario outlines
end

# FIXME: styles should only be injected temporary until The Designers fix it
# example When I inject style "position:relative" into "header"
When /^I inject style #{capture_quoted} into #{capture_quoted}$/ do |style, selector|
  begin
    page.execute_script %Q~$('#{selector}').attr('style', "#{style}");~
  rescue Capybara::NotSupportedByDriverError => e
    # does not matter in pure Rack scenarios
  end
end

When /^I wait for (\d+) seconds$/ do |num|
  sleep num.to_i
end
