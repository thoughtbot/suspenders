require "rails/generators"

module Suspenders
  module Production
    class TimeoutGenerator < Rails::Generators::Base
      def add_gem
        gem "rack-timeout", group: :production
      end

      def configure_rack_timeout
        append_file "config/environments/production.rb", rack_timeout_config
      end

      private

      def rack_timeout_config
        %{Rack::Timeout.timeout = ENV.fetch("RACK_TIMEOUT", 10).to_i}
      end
    end
  end
end
