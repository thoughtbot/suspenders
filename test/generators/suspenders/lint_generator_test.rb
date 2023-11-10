require "test_helper"
require "generators/suspenders/lint_generator"

module Suspenders
  module Generators
    class LintGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::LintGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "adds gem to Gemfile" do
        expected_output = <<~RUBY
          gem "standard", group: [:development, :test]
        RUBY

        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match(expected_output, file)
        end
      end

      test "adds require to Rakefile" do
        expected_output = <<~RUBY
          require "standard/rake"
        RUBY

        run_generator

        assert_file app_root("Rakefile") do |file|
          assert_match(expected_output.strip, file.strip)
        end
      end

      test "installs gem with Bundler" do
        Bundler.stubs(:with_unbundled_env).yields
        generator.expects(:run).with("bundle install").once

        capture(:stdout) do
          generator.setup_standard
        end
      end

      test "generator has a description" do
        description = "Sets up standard"

        assert_equal description, Suspenders::Generators::LintGenerator.desc
      end

      private

      def prepare_destination
        touch "Gemfile"
        touch "Rakefile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "Rakefile"
      end
    end
  end
end
