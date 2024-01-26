require "test_helper"
require "generators/suspenders/setup_generator"

module Suspenders
  module Generators
    class SetupGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::SetupGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "creates Brewfile" do
        expected = <<~TEXT
          # https://formulae.brew.sh/formula/vips
          brew "vips"

          # https://formulae.brew.sh/formula/redis
          brew "redis"

          # https://formulae.brew.sh/formula/postgresql@15
          # Change version to match production
          brew "postgresql@15"
        TEXT

        run_generator

        assert_file app_root("Brewfile") do |file|
          assert_equal expected, file
        end
      end

      test "modifies bin/setup" do
        expected = bin_setup

        run_generator

        assert_file app_root("bin/setup") do |file|
          assert_equal expected, file
        end
      end

      test "creates dev:prime task" do
        expected = <<~RUBY
          if Rails.env.development? || Rails.env.test?
            require "factory_bot" if Bundler.rubygems.find_name("factory_bot_rails").any?

            namespace :dev do
              desc "Sample data for local development environment"
              task prime: "db:setup" do
                include FactoryBot::Syntax::Methods if Bundler.rubygems.find_name("factory_bot_rails").any?

                # create(:user, email: "user@example.com", password: "password")
              end
            end
          end
        RUBY

        run_generator

        assert_file app_root("lib/tasks/dev.rake") do |file|
          assert_equal expected, file
        end
      end

      test "has a custom description" do
        assert_no_match(/Description:/, generator_class.desc)
      end

      private

      def prepare_destination
        backup_file "bin/setup"
      end

      def restore_destination
        remove_file_if_exists "Brewfile"
        restore_file "bin/setup"
        remove_dir_if_exists "lib/tasks"
      end

      def bin_setup
        File.read("./lib/generators/templates/setup/bin_setup.rb")
      end
    end
  end
end
