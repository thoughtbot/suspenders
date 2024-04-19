require "test_helper"
require "generators/suspenders/views_generator"

module Suspenders
  module Generators
    class ViewsGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::ViewsGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "raises if API only application" do
        within_api_only_app do
          assert_raises Suspenders::Generators::APIAppUnsupported::Error do
            run_generator
          end

          assert_file app_root("Gemfile") do |file|
            assert_no_match "title", file
          end
        end
      end

      test "creates flash partial" do
        expected = file_fixture("_flashes.html.erb").read

        run_generator

        assert_file app_root("app/views/application/_flashes.html.erb") do |file|
          assert_equal expected, file
        end
      end

      test "includes flash partial in layout" do
        run_generator

        assert_file app_root("app/views/layouts/application.html.erb") do |file|
          assert_match(/<body>\s{5}<%= render "flashes" -%>$/, file)
        end
      end

      test "sets the language" do
        run_generator

        assert_file app_root("app/views/layouts/application.html.erb") do |file|
          assert_match(/<html lang="<%= I18n.locale %>">/, file)
        end
      end

      test "adds gems to Gemfile" do
        expected_output = <<~RUBY
          gem "title"
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

      test "sets title" do
        run_generator

        assert_file app_root("app/views/layouts/application.html.erb") do |file|
          assert_match(/<title><%= title %><\/title>/, file)
        end
      end

      test "disables InstantClick" do
        run_generator

        assert_file app_root("app/views/layouts/application.html.erb") do |file|
          assert_match(/<head>.*<\/title>\s{4}<meta\s*name="turbo-prefetch"\s*content=\s*"false">/m, file)
        end
      end

      private

      def prepare_destination
        touch "Gemfile"
        backup_file "app/views/layouts/application.html.erb"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "app/views/application/_flashes.html.erb"
        restore_file "app/views/layouts/application.html.erb"
      end
    end
  end
end
