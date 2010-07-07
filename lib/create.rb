# Methods needed to create a project.

require 'rubygems'
require 'digest/md5'
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
      run("mkdir #{project_directory}")
      Dir.chdir(project_directory) or fail("Couldn't change to #{project_directory}")
      run("git init")
      run("git remote add suspenders #{template_url}")
      run("git pull suspenders master")

      Dir.glob("#{project_directory}/**/*.*").each do |file|
        search_and_replace(file, changeme, project_name)
      end

      Dir.glob("#{project_directory}/**/session_store.rb").each do |file|
        datestring = Time.now.strftime("%j %U %w %A %B %d %Y %I %M %S %p %Z")
        search_and_replace(file, changesession, Digest::MD5.hexdigest("#{project_name} #{datestring}"))
      end

      run("git commit -a -m 'Initial commit'")

      run("rake gems:refresh_specs")
      run("rake db:create RAILS_ENV=development")
      run("rake db:create RAILS_ENV=test")

      run("script/generate clearance")
      run("script/generate clearance_features -f")
      run("script/generate clearance_views -f")

      run("git add .")
      run("git commit -m 'installed clearance'")

      puts
      puts "Now login to github and add a new project named '#{project_name}'"
    end

    private

    def changeme
      "CHANGEME"
    end

    def changesession
      "CHANGESESSION"
    end

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

    def search_and_replace(file, search, replace)
      begin
        contents = File.read(file)
        if contents[search]
          puts "Replacing #{search} with #{replace} in #{file}"
          contents.gsub!(search, replace)
          File.open(file, "w") { |f| f << contents }
        end
      rescue Errno::EISDIR => e
        # This is fine, because Dir.glob can't select only files.
      rescue Errno::ENOENT => e
        fail "Attempted to perform a find-and-replace on a missing file: #{file}"
      end
    end
  end
end
