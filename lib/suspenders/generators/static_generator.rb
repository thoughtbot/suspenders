require "rails/generators"

module Suspenders
  class StaticGenerator < Rails::Generators::Base
    def add_high_voltage
      gem "high_voltage"
    end
  end
end
