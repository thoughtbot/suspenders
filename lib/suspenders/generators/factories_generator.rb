require "rails/generators"

module Suspenders
  class FactoriesGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_factory_bot
      gem "factory_bot_rails", group: %i(development test)
      Bundler.with_clean_env { run "bundle install" }
    end

    def set_up_factory_bot_for_rspec
      copy_file "factory_bot_rspec.rb", "spec/support/factory_bot.rb"
    end

    def generate_empty_factories_file
      copy_file "factories.rb", "spec/factories.rb"
    end

    def provide_dev_prime_task
      copy_file "dev.rake", "lib/tasks/dev.rake"
    end
  end
end
