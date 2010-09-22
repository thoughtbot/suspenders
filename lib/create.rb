# Methods needed to create a project.

require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/errors")
require File.expand_path(File.dirname(__FILE__) + "/command")

module Suspenders
  class Create
    attr_accessor :project_name, :template_url, :project_directory
    include Suspenders::Command

    def self.run!(input_project_name, input_template_url)
      creator = self.new(input_project_name, input_template_url)
      creator.create_project!
    end

    def initialize(input_project_name, input_template_url)
      @project_name = valid_project_name!(input_project_name)
      @template_url, @project_directory = valid_template_url!(input_template_url, project_name)
    end

    def create_project!
      Dir.chdir(File.dirname(project_directory))
      run("rails new #{project_name} --template=#{template}")
    end

    private

    def valid_project_name!(project_name)
      unless project_name =~ /^[a-z0-9_]+$/
        raise InvalidInput.new("Project name must only contain [a-z0-9_]")
      else
        project_name
      end
    end

    def valid_template_url!(template_url, project_name)
      base_directory = Dir.pwd
      project_directory = File.join(base_directory, project_name)

      # This is for the common case for the user's convenience; the race
      # condition can still occur.
      if File.exists?(project_directory)
        raise InvalidInput.new("Project directory (#{project_directory}) already exists")
      end

      if template_url && !(template_url =~ /^ *$/)
        [template_url, project_directory]
      else
        ["git://github.com/thoughtbot/suspenders.git", project_directory]
      end
    end

    def template
      File.expand_path(File.dirname(__FILE__) + "/../template/suspenders.rb")
    end
  end
end
