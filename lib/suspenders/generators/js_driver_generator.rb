require_relative "base"

module Suspenders
  class JsDriverGenerator < Generators::Base
    def add_gems
      gem "webdrivers", group: :test
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_capybara
      copy_file "chromedriver.rb", "spec/support/chromedriver.rb"
      copy_file(
        "capybara_silence_puma.rb",
        "spec/support/capybara_silence_puma.rb",
      )
    end
  end
end
