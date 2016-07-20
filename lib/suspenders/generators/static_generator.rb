require "rails/generators"

module Suspenders
  class StaticGenerator < Rails::Generators::Base
    def add_high_voltage
      gem "high_voltage"
      Bundler.with_clean_env { run "bundle install" }
    end
  end
end
