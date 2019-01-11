require_relative "../base"

module Suspenders
  module Production
    class ForceTlsGenerator < Generators::Base
      def config_enforce_ssl
        configure_environment "production", "config.force_ssl = true"
      end
    end
  end
end
