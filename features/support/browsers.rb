module BrowserSupport

  class << self

    def setup_chrome
      if chrome = [`which chromium-browser`, `which google-chrome`].map(&:chomp).reject(&:blank?).first
        Selenium::WebDriver::Chrome.path = chrome
      end
      setup_selenium :chrome,
        :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate],
        :startpage => 'chrome://version/?name=Webdriver'
    end

    def setup_firefox
      setup_selenium :firefox, 
        :startpage => 'about:buildconfig'
    end

    def setup_selenium(browser, opts={})
      unless [:chrome, :firefox].include?(browser)
        raise ArgumentError, "unsupported browser: #{browser}"
      end
      # arbitrary window decorations?
      width = (opts.delete(:width) || 640) + 8
      height = (opts.delete(:height) || 800) + 57
      startpage = opts.delete(:startpage)

      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, opts.merge(:browser => browser)).tap do |driver|
          # Resize window. In Firefox and Chrome, must create a new window to do this.
          # http://groups.google.com/group/webdriver/browse_thread/thread/e4e987eeedfdb586
          browser = driver.browser
          handles = browser.window_handles
          browser.execute_script("window.open('#{startpage}','_blank','width=#{width},height=#{height}');")
          browser.close
          browser.switch_to.window((browser.window_handles - handles).pop)
          browser.execute_script("window.resizeTo(#{width}, #{height}); window.moveTo(1,1);")
        end
      end
    end

  end

end
