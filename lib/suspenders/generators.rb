require "active_support/concern"

module Suspenders
  module Generators
    module Helpers
      def default_test_suite?
        File.exist? Rails.root.join("test")
      end

      def rspec_test_suite?
        File.exist? Rails.root.join("spec/spec_helper.rb")
      end

      def default_test_helper_present?
        File.exist? Rails.root.join("test/test_helper.rb")
      end

      def rspec_test_helper_present?
        File.exist? Rails.root.join("spec/rails_helper.rb")
      end
    end

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

    module DatabaseUnsupported
      class Error < StandardError
        def message
          "This generator requires PostgreSQL"
        end
      end

      extend ActiveSupport::Concern

      included do
        def raise_if_database_unsupported
          if database_unsupported?
            raise Suspenders::Generators::DatabaseUnsupported::Error
          end
        end

        private

        def database_unsupported?
          configuration = File.read(Rails.root.join("config/database.yml"))
          configuration = YAML.load(configuration, aliases: true)
          adapter = configuration["default"]["adapter"]

          adapter != "postgresql"
        end
      end
    end
  end
end
