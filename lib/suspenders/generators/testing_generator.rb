require "rails/generators"

module Suspenders
  class TestingGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_testing_gems
      gem "spring-commands-rspec", group: :development
      gem "rspec-rails", "~> 3.6", group: %i(development test)
      gem "shoulda-matchers", group: :test

      Bundler.with_clean_env { run "bundle install" }
    end

    def generate_rspec
      generate "rspec:install"
    end

    def configure_rspec
      remove_file "spec/rails_helper.rb"
      remove_file "spec/spec_helper.rb"
      copy_file "rails_helper.rb", "spec/rails_helper.rb"
      copy_file "spec_helper.rb", "spec/spec_helper.rb"
    end

    def provide_shoulda_matchers_config
      copy_file(
        "shoulda_matchers_config_rspec.rb",
        "spec/support/shoulda_matchers.rb",
      )
    end

    def configure_spec_support_features
      empty_directory_with_keep_file "spec/features"
      empty_directory_with_keep_file "spec/support/features"
    end

    def configure_i18n_for_test_environment
      copy_file "i18n.rb", "spec/support/i18n.rb"
    end

    def configure_action_mailer_in_specs
      copy_file "action_mailer.rb", "spec/support/action_mailer.rb"
    end

    private

    def empty_directory_with_keep_file(destination)
      empty_directory(destination, {})
      keep_file(destination)
    end

    def keep_file(destination)
      create_file(File.join(destination, ".keep"))
    end
  end
end
