require "test_helper"
require "generators/suspenders/rake_generator"

module Suspenders
  module Generators
    class RakeGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::RakeGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "modifies existing Rakefile" do
        content = file_fixture("Rakefile").read

        run_generator

        assert_file app_root("Rakefile") do |file|
          assert_equal content, file
        end
      end

      test "generator has a description" do
        description = <<~TEXT
          Configures the default Rake task to audit and lint the codebase with
          `bundler-audit` and `standard`, in addition to running the test suite.
        TEXT

        assert_equal description, generator_class.desc
      end

      private

      def prepare_destination
        touch "Gemfile"
        backup_file "Rakefile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        restore_file "Rakefile"
      end
    end
  end
end
