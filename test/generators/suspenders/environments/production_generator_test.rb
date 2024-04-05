require "test_helper"
require "generators/suspenders/environments/production_generator"

module Suspenders
  module Generators
    module Environments
      class ProductionGeneratorTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Environments::ProductionGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "requires master key" do
          run_generator

          assert_file app_root("config/environments/production.rb") do |file|
            assert_match(/^\s*config\.require_master_key\s*=\s*true/, file)
          end
        end

        test "requires master key (when config is not commented out)" do
          content = file_fixture("environments/production.rb").read
          remove_file_if_exists "config/environments/production.rb"
          touch "config/environments/production.rb", content: content

          run_generator

          assert_file app_root("config/environments/production.rb") do |file|
            assert_match(/^\s*config\.require_master_key\s*=\s*true/, file)
          end
        end

        private

        def prepare_destination
          backup_file "config/environments/production.rb"
        end

        def restore_destination
          restore_file "config/environments/production.rb"
        end
      end
    end
  end
end
