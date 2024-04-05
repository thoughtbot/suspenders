require "test_helper"
require "generators/suspenders/environments/development_generator"

module Suspenders
  module Generators
    module Environments
      class DevelopmentGenerator::DefaultTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Environments::DevelopmentGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "raise on missing translations" do
          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(
              /^ +config.i18n.raise_on_missing_translations = true$/,
              file
            )
          end
        end

        test "raise on missing translations (when config is not commented out)" do
          content = file_fixture("environments/development.rb").read
          remove_file_if_exists "config/environments/development.rb"
          touch "config/environments/development.rb", content: content

          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(
              /^ +config.i18n.raise_on_missing_translations = true$/,
              file
            )
          end
        end

        test "annotate rendered view with file names" do
          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(
              /^ +config.action_view.annotate_rendered_view_with_filenames = true$/,
              file
            )
          end
        end

        test "annotate rendered view with file names (when config is not commented out)" do
          content = file_fixture("environments/development.rb").read
          remove_file_if_exists "config/environments/development.rb"
          touch "config/environments/development.rb", content: content

          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(
              /^ +config.action_view.annotate_rendered_view_with_filenames = true$/,
              file
            )
          end
        end

        test "enable active_model.i18n_customize_full_message" do
          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(/^\s*config\.active_model\.i18n_customize_full_message\s*=\s*true/, file)
          end
        end

        test "enable active_record.query_log_tags_enabled" do
          run_generator

          assert_file app_root("config/environments/development.rb") do |file|
            assert_match(/^\s*config\.active_record\.query_log_tags_enabled\s*=\s*true/, file)
          end
        end

        private

        def prepare_destination
          backup_file "config/environments/development.rb"
        end

        def restore_destination
          restore_file "config/environments/development.rb"
        end
      end
    end
  end
end
