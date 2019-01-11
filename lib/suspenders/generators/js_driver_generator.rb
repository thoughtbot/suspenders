require_relative "base"

module Suspenders
  class JsDriverGenerator < Generators::Base
    def add_gems
      gem "capybara-selenium", group: :test
      gem "chromedriver-helper", group: :test
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_chromedriver
      copy_file "chromedriver.rb", "spec/support/chromedriver.rb"
    end
  end
end
