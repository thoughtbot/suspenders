extend Suspenders::Generators::Helpers

def apply_template!
  if node_not_installed? || node_version_unsupported?
    message = <<~ERROR


    === Node version unsupported ===

    Suspenders requires Node >= #{Suspenders::MINIMUM_NODE_VERSION}
    ERROR

    fail Rails::Generators::Error, message
  end
  if options[:database] == "postgresql" && options[:skip_test]
    after_bundle do
      gem_group :development, :test do
        # TODO: Update once in `main`
        gem "suspenders", github: "thoughtbot/suspenders", branch: "suspenders-3-0-0"
      end

      run "bundle install"

      generate "suspenders:install:web"
      rails_command "db:prepare"

      say "\nCongratulations! You just pulled our suspenders."
    end
  else
    message = <<~ERROR


      === Please use the correct options ===

      rails new <app_name> \\
      --skip-test \\
      -d=postgresql \\
      -m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
    ERROR

    fail Rails::Generators::Error, message
  end
end

apply_template!
