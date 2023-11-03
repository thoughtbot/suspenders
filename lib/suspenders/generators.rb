require "active_support/concern"

module Suspenders
  module Generators
    module APIAppUnsupported
      class Error < StandardError
        def message
          "This generator cannot be used on API only applications."
        end
      end

      extend ActiveSupport::Concern

      included do
        def raise_if_api_only_app
          if api_only_app?
            raise Suspenders::Generators::APIAppUnsupported::Error
          end
        end
      end

      private

      def api_only_app?
        File.read(Rails.root.join("config/application.rb"))
          .match?(/^\s*config\.api_only\s*=\s*true/i)
      end
    end
  end
end
