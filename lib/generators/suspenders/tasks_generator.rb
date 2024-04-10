module Suspenders
  module Generators
    class TasksGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/tasks", __FILE__)
      desc <<~MARKDOWN
        Creates local Rake tasks for development

        bin/rails dev:prime # Sample data for local development environment
      MARKDOWN

      def create_dev_rake
        if Bundler.rubygems.find_name("factory_bot").any?
          copy_file "dev.rake", "lib/tasks/dev.rake"
        else
          say "This generator requires Factory Bot"
        end
      end
    end
  end
end
