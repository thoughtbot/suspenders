require_relative "../base"

module Bulldozer
  module Production
    class ForceTlsGenerator < Generators::Base
      def config_enforce_ssl
        configure_environment "production", "config.force_ssl = true"
      end
    end
  end
end
