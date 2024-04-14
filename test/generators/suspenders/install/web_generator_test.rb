require "test_helper"
require "generators/suspenders/install/web_generator"

module Suspenders
  module Generators
    module Install
      class WebGeneratorTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Install::WebGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "raises if API only application" do
          within_api_only_app do
            assert_raises Suspenders::Generators::APIAppUnsupported::Error do
              run_generator
            end
          end
        end

        test "raises if PostgreSQL is not the adapter" do
          with_database "unsupported" do
            assert_raises Suspenders::Generators::DatabaseUnsupported::Error do
              run_generator
            end
          end
        end

        private

        def prepare_destination
          touch "Gemfile"
        end

        def restore_destination
          remove_file_if_exists "Gemfile"
        end
      end
    end
  end
end
