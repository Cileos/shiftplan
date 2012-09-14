# in June 2012 selenium(-webdriver) did not wait for the page to be loaded, and
# travis ran the testsuite faster than the browser, which resulted in a lot of
# missing dom elements.
# 
# Now we wait for for this after each click

module PageLoadSupport

  def wait_for_the_page_to_be_loaded
    unless page.mode == :rack_test
      within page.send(:scopes).first do
        wait_until { page.has_css?('html.loaded') }
      end
    end
  rescue Selenium::WebDriver::Error::UnhandledAlertError => e
    # modal dialog
  end

end

World(PageLoadSupport)
