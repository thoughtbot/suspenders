# Methods needed to create a project.

require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/errors")

module Suspenders
  class Create
    attr_accessor :project_path, :repo

    def self.run!(project_path, repo)
      creator = self.new(project_path, repo)
      creator.create_project!
    end

    def initialize(project_path, repo)
      self.project_path = File.expand_path(project_path)
      validate_project_path
      validate_project_name
      self.repo = repo if present?(repo)
    end

    def create_project!
      command = <<-COMMAND
        rails #{rails_version} new #{project_path} \
          --template=#{template} \
          --skip-test-unit \
          --skip-prototype \
          --database=postgresql
      COMMAND
      command_with_repo = if repo
                            "REPO='#{repo}' #{command}"
                          else
                            command
                          end
      exec(command_with_repo)
    end

    private

    def validate_project_name
      project_name = File.basename(project_path)
      unless project_name =~ /^[a-z0-9_]+$/
        raise InvalidInput.new("Project name must only contain [a-z0-9_]")
      end
    end

    def validate_project_path
      base_directory = Dir.pwd
      full_path = File.join(base_directory, project_path)

      # This is for the common case for the user's convenience; the race
      # condition can still occur.
      if File.exists?(full_path)
        raise InvalidInput.new("Project directory (#{project_path}) already exists")
      end
    end

    def template
      File.expand_path(File.join("..", "template", "suspenders.rb"), File.dirname(__FILE__))
    end

    def gemfile
      File.expand_path(File.join("..", "template", "trout", "Gemfile"), File.dirname(__FILE__))
    end

    def rails_version
      gemfile_contents = File.read(gemfile)
      gemfile_contents =~ /gem "rails", "(.*)"/
      if $1.nil? || $1 == ''
        ''
      else
        "_#{$1}_"
      end
    end

    def present?(string)
      string && string != ''
    end
  end
end
