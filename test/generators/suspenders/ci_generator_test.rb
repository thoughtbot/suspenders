require "test_helper"
require "generators/suspenders/ci_generator"

module Suspenders
  module Generators
    class CiGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::CiGenerator
      destination Rails.root
      teardown :restore_destination

      test "generates CI files" do
        mkdir(".github/workflows")
        touch(".github/workflows/ci.yml")

        with_database "postgresql" do
          run_generator

          assert_file app_root(".github/workflows/ci.yml")
        end
      end

      test "raises if PostgreSQL is not the adapter" do
        with_database "unsupported" do
          assert_raises Suspenders::Generators::DatabaseUnsupported::Error, match: "This generator requires PostgreSQL" do
            run_generator

            assert_no_file app_root(".github/workflows/ci.yml")
          end
        end
      end

      private

      def restore_destination
        remove_dir_if_exists ".github"
      end
    end
  end
end
