# in June 2012 selenium(-webdriver) did not wait for the page to be loaded, and
# travis ran the testsuite faster than the browser, which resulted in a lot of
# missing dom elements.
# 
# Now we wait for for this after each click

module PageLoadSupport

  def wait_for_the_page_to_be_loaded
    unless page.mode == :rack_test
      within page.send(:scopes).first do
        page.should have_css('html.loaded')
      end
    end
  rescue Selenium::WebDriver::Error::UnhandledAlertError => e
    unless e.message =~ /An open modal dialog blocked the operation/
      raise e
    end
  rescue Capybara::CapybaraError => e
    if page.body =~ /Internal Server Error/
      raise page.body.sub(/(Internal Server Error)/, '\1 (full trace in log/capybara_test.log)')
    else
      raise e
    end
  end

end

World(PageLoadSupport)
