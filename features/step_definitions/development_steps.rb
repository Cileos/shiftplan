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

When /^I want pry later$/ do
  $want_pry = true
end

After do |scenario|
  $want_pry = false
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

Before do |scenario|
  if scenario.respond_to?(:title) && scenario.respond_to?(:file_colon_line)
    Rails.logger.debug { "oooooo BEGIN Scenario #{scenario.title.inspect} (#{scenario.file_colon_line})" }
  end
end

After do |scenario|
  if scenario.respond_to?(:title) && scenario.respond_to?(:file_colon_line)
    Rails.logger.debug { "oooooo END Scenario #{scenario.title.inspect} (#{scenario.file_colon_line})" }
  end
end

module BenchmarkingHelper
  def benchmark(description='something slow', &block)
    ms = Benchmark.ms &block
    STDERR.puts 'Benchmark %s: (%.2fs)' % [description, ms/1000]
  end
end
World(BenchmarkingHelper)

module ComplicatedCSSHelper
  # When your selector raises
  # "Selenium::WebDriver::Error::InvalidElementStateError: invalid element
  # state: Failed to execute query: '<CSS>' is not a valid selector", wrap it
  # with this.
  #
  # (before version 2, capybara did this automatically)
  def complicated_css(css)
    Nokogiri::CSS.xpath_for(css).first
  end

  # Capybara 2 ignores hidden elements by default. It is a good thing (TM).
  # With this, you can still see them (for example the page title)
  def not_ignoring_hidden_elements
    old = Capybara.ignore_hidden_elements
    Capybara.ignore_hidden_elements = false
    yield
  ensure
    Capybara.ignore_hidden_elements = old
  end
end
World(ComplicatedCSSHelper)
