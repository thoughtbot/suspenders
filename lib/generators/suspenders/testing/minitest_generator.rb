module Suspenders
  module Generators
    module Testing
      class MinitestGenerator < Rails::Generators::Base
        def add_gems
          gem_group :test do
            gem "webmock"
          end

          Bundler.with_unbundled_env { run "bundle install" }
        end

        def modify_test_helper
          webmock_config = <<~RUBY

            WebMock.disable_net_connect!(
              allow_localhost: true,
              allow: "chromedriver.storage.googleapis.com"
            )
          RUBY

          insert_into_file "test/test_helper.rb", webmock_config

          insert_into_file "test/test_helper.rb",
            "\s\s\s\sinclude ActionView::Helpers::TranslationHelper\n" \
            "\s\s\s\sinclude ActionMailer::TestCase::ClearTestDeliveries\n\n",
            after: "class TestCase\n"
        end

        def remove_spec_directory
          path = Rails.root.join("spec")

          FileUtils.rm_r path if File.exist? path
        end
      end
    end
  end
end
