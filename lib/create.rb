# Methods needed to create a project.

require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/errors")
require File.expand_path("../template/suspenders", File.dirname(__FILE__))

module Suspenders
  class Create
    attr_accessor :project_path, :repo

    def self.run!
      creator = self.new
      creator.create_project!
    end

    def create_project!
      Suspenders::Generator.source_root templates_root
      Suspenders::Generator.source_paths << Rails::Generators::AppGenerator.source_root << templates_root

      Suspenders::Generator.start
    end

    private

    def gemfile
      File.expand_path(File.join("..", "template", "trout", "Gemfile"), File.dirname(__FILE__))
    end

    def templates_root
      File.expand_path(File.join("..", "template", "files"), File.dirname(__FILE__))
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
