require_relative "base"

module Suspenders
  class JsDriverGenerator < Generators::Base
    def add_gems
      gem "webdrivers", group: :test
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def configure_capybara
      copy_file "chromedriver.rb", "spec/support/chromedriver.rb"
    end
  end
end
