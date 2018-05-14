require "rails/generators"

module Suspenders
  class ChromedriverGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_gems
      gem "capybara-selenium", group: :test
      gem "chromedriver-helper", group: :test
    end
    
    def remove_capybara_webkit
      remove_file "spec/support/capybara_webkit.rb"
    end

    def configure_chromedriver
      copy_file "chromedriver.rb", "spec/support/chromedriver.rb"
    end
  end
end
