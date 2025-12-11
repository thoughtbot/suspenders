module Suspenders
  class CLI
    BASE_OPTIONS = ["-d=postgresql", "--skip-solid", "--skip-test"]

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
      template_path = File.expand_path("../generators/templates/base.rb", __dir__)
      options = BASE_OPTIONS + ["-m=#{template_path}"]

      if system("rails", "new", app_name, *options)
        true
      else
        warn "Failed to create Rails application: #{app_name}"
        false
      end
    end
  end
end
