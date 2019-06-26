require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    options: options
end

Capybara.javascript_driver = :headless_chrome
