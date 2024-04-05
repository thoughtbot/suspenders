require "test_helper"
require "generators/suspenders/environments/test_generator"

module Suspenders
  module Generators
    module Environments
      class TestGeneratorTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Environments::TestGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "raise on missing translations" do
          run_generator

          assert_file app_root("config/environments/test.rb") do |file|
            assert_match(/^\s*config\.i18n\.raise_on_missing_translations\s*=\s*true/, file)
          end
        end

        test "raise on missing translations (when config is not commented out)" do
          content = file_fixture("environments/test.rb").read
          remove_file_if_exists "config/environments/test.rb"
          touch "config/environments/test.rb", content: content

          run_generator

          assert_file app_root("config/environments/test.rb") do |file|
            assert_match(/^\s*config\.i18n\.raise_on_missing_translations\s*=\s*true/, file)
          end
        end

        test "disable action_dispatch.show_exceptions" do
          run_generator

          assert_file app_root("config/environments/test.rb") do |file|
            assert_match(/^\s*config\.action_dispatch\.show_exceptions\s*=\s*:none/, file)
            assert_no_match(/^\s*config\.action_dispatch\.show_exceptions\s*=\s*:rescuable/, file)
            assert_no_match(/^\s*#\s*Raise exceptions instead of rendering exception templates/i, file)
          end
        end

        test "disable action_dispatch.show_exceptions (when config does not exist)" do
          content = file_fixture("environments/test.rb").read
          remove_file_if_exists "config/environments/test.rb"
          touch "config/environments/test.rb", content: content

          run_generator

          assert_file app_root("config/environments/test.rb") do |file|
            assert_match(/^\s*config\.action_dispatch\.show_exceptions\s*=\s*:none/, file)
          end
        end

        private

        def prepare_destination
          backup_file "config/environments/test.rb"
        end

        def restore_destination
          restore_file "config/environments/test.rb"
        end
      end
    end
  end
end
