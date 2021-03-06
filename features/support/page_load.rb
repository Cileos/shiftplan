# in June 2012 selenium(-webdriver) did not wait for the page to be loaded, and
# travis ran the testsuite faster than the browser, which resulted in a lot of
# missing dom elements.
# 
# Now we wait for for this after each click

module PageLoadSupport

  def wait_for_the_page_to_be_loaded
    unless page.mode == :rack_test
      # capybara cannot look into the header
      page.wait_until do
        evaluate_script(%Q~$('html.loaded').length~) == 1
      end
      some_time_passes
    end
  rescue Selenium::WebDriver::Error::UnhandledAlertError => e
    unless e.message =~ /An open modal dialog blocked the operation/
      raise e
    end
  rescue Selenium::WebDriver::Error::UnknownError => e
    raise page.body.sub(/(Internal Server Error)/, '\1 (full trace in log/capybara_test.log)')
  rescue Capybara::CapybaraError => e
    if page.body =~ /Internal Server Error/
      raise page.body.sub(/(Internal Server Error)/, '\1 (full trace in log/capybara_test.log)')
    else
      raise e
    end
  end

  def some_time_passes
    # we fake the time for JS with sinon. Because EmberJS is based on
    # Backburner, it needs a _running_ clock to initialize

    execute_script <<-EOJS
      if (typeof clock !== "undefined" && clock !== null) {
        clock.tick(2);
      }
    EOJS
    step %Q~I wait for the spinner to stop~
  end

end

World(PageLoadSupport)
