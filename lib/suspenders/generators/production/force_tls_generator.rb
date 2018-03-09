require "rails/generators"
require_relative "../../actions"

module Suspenders
  module Production
    class ForceTlsGenerator < Rails::Generators::Base
      include Suspenders::Actions

      def config_enforce_ssl
        configure_environment "production", "config.force_ssl = true"
      end
    end
  end
end
