require "test_helper"
require "generators/suspenders/production_environment_generator"

module Suspenders
  module Generators
    class ProductionEnvironmentGenerator::DefaultTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::ProductionEnvironmentGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "configures the asset host" do
        run_generator
        assert_file app_root("config/environments/production.rb") do |file|
          assert_match(
            /^ +config.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))$/,
            file
          )
        end
      end

      private

      def prepare_destination
        backup_file "config/environments/produciton.rb"
      end

      def restore_destination
        restore_file "config/environments/produciton.rb"
      end
    end
  end
end
