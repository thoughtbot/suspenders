require_relative "../base"

module Suspenders
  module Production
    class TimeoutGenerator < Generators::Base
      def add_gem
        gem "rack-timeout", group: :production
        Bundler.with_clean_env { run "bundle install" }
      end

      def configure_rack_timeout
        append_file ".env", rack_timeout_config
      end

      private

      def rack_timeout_config
        %{RACK_TIMEOUT_SERVICE_TIMEOUT=10}
      end
    end
  end
end
