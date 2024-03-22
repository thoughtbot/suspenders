require "test_helper"
require "generators/suspenders/prerequisites_generator"

module Suspenders
  module Generators
    class PrerequisitesGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::PrerequisitesGenerator
      destination Rails.root
      teardown :restore_destination

      test "generates .node-version file" do
        run_generator

        assert_file app_root(".node-version") do |file|
          assert_match(/20\.11\.1/, file)
        end
      end

      test "has custom description" do
        assert_no_match(/Description/, generator.class.desc)
      end

      private

      def restore_destination
        remove_file_if_exists ".node-version"
      end
    end
  end
end
