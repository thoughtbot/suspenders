require "rails/generators"

module Suspenders
  class JsDriverGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_gems
      gem "capybara-webkit", group: :test

      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_capybara_webkit
      copy_file "capybara_webkit.rb", "spec/support/capybara_webkit.rb"
    end
  end
end
