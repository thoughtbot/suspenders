module Suspenders
  module Generators
    class TasksGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/tasks", __FILE__)
      desc <<~MARKDOWN
        Creates `lib/tasks/development.rake` which contains the following tasks:

        `bin/rails development:seed` which loads data into development
        `bin/rails development:seed:replant` which truncate tables of each database for development and loads seed data
      MARKDOWN

      def create_dev_rake
        if Bundler.rubygems.find_name("factory_bot").any?
          copy_file "development.rake", "lib/tasks/development.rake"
        else
          say "This generator requires Factory Bot"
        end
      end

      def create_seeder_file
        if Bundler.rubygems.find_name("factory_bot").any?
          copy_file "seeder.rb", "lib/seeder.rb"
        else
          say "This generator requires Factory Bot"
        end
      end
    end
  end
end
