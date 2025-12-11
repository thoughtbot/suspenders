module Suspenders
  class CLI
    BASE_OPTIONS = ["-d=postgresql"]

    def initialize(app_name)
      @app_name = app_name
    end

    def self.run(app_name)
      new(app_name).run
    end

    def run
      verify_rails_exists!
      rails_new_command
    end

    private

    attr_reader :app_name

    def verify_rails_exists!
      unless system("which", "rails", out: File::NULL, err: File::NULL)
        raise Error, "Rails not found. Install with: gem install rails"
      end
    end

    def rails_new_command
      options = BASE_OPTIONS

      if system("rails", "new", app_name, *options)
        true
      else
        Rails.logger.error "Failed to create Rails application: #{app_name}"
        false
      end
    end 
  end
end