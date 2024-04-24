require "test_helper"
require "generators/suspenders/jobs_generator"

module Suspenders
  module Generators
    class JobsGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::JobsGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "adds gems to Gemfile" do
        expected_output = <<~RUBY
          gem "sidekiq"
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

      test "adds ActiveJob configuration to the application file" do
        run_generator

        assert_file app_root("config/application.rb") do |file|
          assert_match(/config.active_job.queue_adapter = :sidekiq/, file)
        end
      end

      test "adds ActiveJob configuration to the test environment file" do
        run_generator

        assert_file app_root("config/environments/test.rb") do |file|
          assert_match(/config.active_job.queue_adapter = :inline/, file)
        end
      end

      test "creates a Procfile.dev with Sidekiq configuration" do
        run_generator

        assert_file app_root("Procfile.dev") do |file|
          assert_match(/worker: bundle exec sidekiq/, file)
        end
      end

      test "adds Sidekiq configuration if procfile exists" do
        touch "Procfile.dev"

        run_generator

        assert_file app_root("Procfile.dev") do |file|
          assert_match(/worker: bundle exec sidekiq/, file)
        end
      end

      private

      def prepare_destination
        touch "Gemfile"
        backup_file "config/application.rb"
        backup_file "config/environments/test.rb"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "config/initializers/active_job.rb"
        remove_file_if_exists "Procfile.dev"
        restore_file "config/application.rb"
        restore_file "config/environments/test.rb"
      end
    end
  end
end
