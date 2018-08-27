require "rails/generators"

module Suspenders
  class CiGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__))

    def configure_ci
      empty_directory(".circleci")
      template "circleci.yml.erb", ".circleci/config.yml"
    end
  end
end
