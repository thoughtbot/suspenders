require "test_helper"
require "generators/suspenders/advisories_generator"

module Suspenders
  module Generators
    class AdvisoriesGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::AdvisoriesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "adds gems to Gemfile" do
        expected_output = <<~RUBY
          group :development, :test do
            gem "bundler-audit", ">= 0.7.0", require: false
          end
        RUBY

        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match(expected_output, file)
        end
      end

      test "installs gems with Bundler" do
        output = run_generator

        assert_match(/bundle install/, output)
      end

      test "generator has a description" do
        description = <<~TEXT
          Show security advisories during development.

          Uses the `bundler-audit` gem to update the local security database and
          show any relevant issues with the app's dependencies via a Rake task.
        TEXT

        assert_equal description, Suspenders::Generators::AdvisoriesGenerator.desc
      end

      test "modifies Rakefile" do
        touch "Rakefile", content: <<~TEXT
          require_relative "config/application"

          Rails.application.load_tasks
        TEXT
        expected_rakefile = file_fixture("Rakefile").read

        run_generator

        assert_file app_root("Rakefile") do |file|
          assert_equal expected_rakefile, file
        end
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
