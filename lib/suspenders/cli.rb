# frozen_string_literal: true

module Suspenders
  class CLI
    BASE_OPTIONS = [
      "-d=postgresql",
      "--skip-test",
      "--skip-solid"
    ]

    def initialize(app_name)
      @app_name = app_name
    end

    def self.run(app_name)
      new(app_name).run
    end

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
      options = BASE_OPTIONS + ["-m=#{template_path}"]

      if system("rails", "new", app_name, *options)
        true
      else
        raise Error, "Failed to create Rails app"
      end
    end
  end
end
