def apply_template!
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
