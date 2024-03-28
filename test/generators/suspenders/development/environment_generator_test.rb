require "test_helper"
require "generators/suspenders/development/environment_generator"

module Suspenders
  module Generators
    module Development
      class EnvironmentGenerator::DefaultTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Development::EnvironmentGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "raise on missing translations in development" do
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

        # config.action_view.annotate_rendered_view_with_filenames

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
