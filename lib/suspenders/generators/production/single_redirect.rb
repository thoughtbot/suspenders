require_relative "../base"

module Suspenders
  module Production
    class SingleRedirect < Generators::Base
      def add_rack_canonical_host
        inject_into_file(
          "config/environments/production.rb",
          %{\n  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")},
          before: "\nend"
        )
      end
    end
  end
end
