# frozen_string_literal: true

module Suspenders
  # Command-line interface for generating Rails applications with Suspenders.
  # This class handles the creation of new Rails apps using a custom template
  # and predefined configuration options.
  class CLI
    # Base options passed to the Rails generator for all new applications.
    # These options configure PostgreSQL as the database, skip test setup,
    # and skip Solid-related features.
    BASE_OPTIONS = [
      "-d=postgresql",
      "--skip-test",
      "--skip-solid"
    ]

    # Initializes a new CLI instance.
    #
    # @param app_name [String] the name of the Rails application to create
    def initialize(app_name)
      @app_name = app_name
    end

    # Creates and runs a new CLI instance for the given application name.
    #
    # @param app_name [String] the name of the Rails application to create
    # @return [Boolean] true if the Rails app was created successfully
    # @raise [Error] if Rails is not installed or app creation fails
    def self.run(app_name)
      new(app_name).run
    end

    # Executes the CLI workflow to generate a new Rails application.
    # Verifies Rails installation and generates the app with Suspenders template.
    #
    # @return [Boolean] true if the Rails app was created successfully
    # @raise [Error] if Rails is not installed or app creation fails
    def run
      verify_rails_exists!
      generate_new_rails_app
    end

    private

    attr_reader :app_name

    def verify_rails_exists!
      unless system("which", "rails", out: File::NULL, err: File::NULL)
        raise Error, "Rails not found. Install with: gem install rails"
      end
    end

    def generate_new_rails_app
      template_path = File.expand_path("../templates/web.rb", __dir__)
      options = BASE_OPTIONS + ["-m=#{template_path}", "--edge"]

      if system("rails", "new", app_name, *options)
        true
      else
        raise Error, "Failed to create Rails app"
      end
    end
  end
end
