require "test_helper"
require "generators/suspenders/testing/minitest_generator"

module Suspenders
  module Generators
    module Testing
      class MinitestGeneratorTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Testing::MinitestGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "adds gems to Gemfile" do
          expected = <<~RUBY
            group :test do
              gem "webmock"
            end
          RUBY

          run_generator

          assert_file app_root("Gemfile") do |file|
            assert_match(expected, file)
          end
        end

        test "installs gems with Bundler" do
          output = run_generator

          assert_match(/bundle install/, output)
        end

        test "configures test helper" do
          expected = <<~RUBY
            ENV["RAILS_ENV"] ||= "test"
            require_relative "../config/environment"
            require "rails/test_help"

            module ActiveSupport
              class TestCase
                include ActionView::Helpers::TranslationHelper
                include ActionMailer::TestCase::ClearTestDeliveries

              end
            end

            WebMock.disable_net_connect!(
              allow_localhost: true,
              allow: "chromedriver.storage.googleapis.com"
            )
          RUBY

          run_generator

          assert_file app_root("test/test_helper.rb") do |file|
            assert_equal expected, file
          end
        end

        test "removes spec directory" do
          mkdir "spec"

          run_generator

          assert_no_directory app_root("spec")
        end

        test "has a custom description" do
          skip
        end

        def prepare_destination
          touch "Gemfile"
          mkdir "test"
          touch "test/test_helper.rb", content: test_helper
        end

        def restore_destination
          remove_file_if_exists "Gemfile"
          remove_dir_if_exists "test"
        end

        def test_helper
          <<~RUBY
            ENV["RAILS_ENV"] ||= "test"
            require_relative "../config/environment"
            require "rails/test_help"

            module ActiveSupport
              class TestCase
              end
            end
          RUBY
        end
      end
    end
  end
end
