require "rails/generators"

module Suspenders
  class CapybaraGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_capybara
      gem "capybara-webkit", group: [:test]
    end

    def configure_capybara_webkit
      copy_file "capybara_webkit.rb", "spec/support/capybara_webkit.rb"
    end
  end
end
