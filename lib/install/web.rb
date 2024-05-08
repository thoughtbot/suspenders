def node_version
  ENV["NODE_VERSION"] || `node --version`[/\d+\.\d+\.\d+/]
end

def node_not_installed?
  !node_version.present?
end

def node_version_unsupported?
  node_version < "20.0.0"
end

def apply_template!
  if node_not_installed? || node_version_unsupported?
    message = <<~ERROR


    === Node version unsupported ===

    Suspenders requires Node >= 20.0.0
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
