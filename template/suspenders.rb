# Suspenders
# =============
# by thoughtbot

require 'net/http'
require 'net/https'

template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

# Helpers

def concat_file(source, destination)
  contents = IO.read(find_in_source_paths(source))
  append_file destination, contents
end

def replace_in_file(relative_path, find, replace)
  path = File.join(destination_root, relative_path)
  contents = IO.read(path)
  unless contents.gsub!(find, replace)
    raise "#{find.inspect} not found in #{relative_path}"
  end
  File.open(path, "w") { |file| file.write(contents) }
end

def action_mailer_host(rails_env, host)
  inject_into_file(
    "config/environments/#{rails_env}.rb",
    "\n\n  config.action_mailer.default_url_options = { :host => '#{host}' }",
    :before => "\nend"
  )
end

def download_file(uri_string, destination)
  uri = URI.parse(uri_string)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri_string =~ /^https/
  request = Net::HTTP::Get.new(uri.path)
  contents = http.request(request).body
  path = File.join(destination_root, destination)
  File.open(path, "w") { |file| file.write(contents) }
end

def origin
  if ENV['REPO'].present?
    ENV['REPO']
  else
    "git://github.com/thoughtbot/suspenders.git"
  end
end

def trout(destination_path)
  run "trout checkout --source-root=template/trout #{destination_path} #{origin}"
end

say "Getting rid of files we don't use"

remove_file "README"
remove_file "public/index.html"
remove_file "public/images/rails.png"

say "Setting up the staging environment"

run "cp config/environments/production.rb config/environments/staging.rb"

say "Creating suspenders views"

empty_directory "app/views/shared"
copy_file "_flashes.html.erb", "app/views/shared/_flashes.html.erb"
copy_file "_javascript.html.erb", "app/views/shared/_javascript.html.erb"
template "suspenders_layout.html.erb.erb",
         "app/views/layouts/application.html.erb",
         :force => true

trout 'Gemfile'
run "bundle install"

say "Pulling in some common javascripts"

trout "app/assets/javascripts/prefilled_input.js"

say "Documentation"

copy_file "README_FOR_SUSPENDERS", "doc/README_FOR_SUSPENDERS"

say "Get ready for bundler... (this will take a while)"

say "Let's use PostgreSQL"

template "postgresql_database.yml.erb", "config/database.yml", :force => true
rake "db:create"

say "Setting up plugins"

generators_config = <<-RUBY
    config.generators do |generate|
      generate.test_framework :rspec
    end
RUBY
inject_into_class "config/application.rb", "Application", generators_config

action_mailer_host "development", "#{app_name}.local"
action_mailer_host "test",        "example.com"
action_mailer_host "staging",     "staging.#{app_name}.com"
action_mailer_host "production",  "#{app_name}.com"

generate "rspec:install"
generate "cucumber:install", "--rspec --capybara"
generate "clearance:install"
generate "clearance:features"

copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"

replace_in_file "spec/spec_helper.rb", "mock_with :rspec", "mock_with :mocha"

inject_into_file "features/support/env.rb",
                 %{Capybara.save_and_open_page_path = 'tmp'\n} +
                 %{Capybara.javascript_driver = :webkit\n},
                 :before => %{Capybara.default_selector = :css}

say "Set up stylesheets including flutie"

copy_file "app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss"
remove_file "app/assets/stylesheets/application.css"
concat_file "import_scss_styles", "app/assets/stylesheets/application.css.scss"
create_file "app/assets/stylesheets/_screen.scss"

say "Ignore the right files"

concat_file "suspenders_gitignore", ".gitignore"
concat_file "cucumber_assertions_hack", "features/support/env.rb"

["app/models",
 "app/views/pages",
 "db/migrate",
 "log",
 "public/images",
 "spec/support",
 "spec/lib",
 "spec/models",
 "spec/views",
 "spec/controllers",
 "spec/helpers",
 "spec/support/matchers",
 "spec/support/mixins",
 "spec/support/shared_examples"].each do |dir|
  empty_directory_with_gitkeep dir
end

say "Copying miscellaneous support files"

copy_file "errors.rb", "config/initializers/errors.rb"
copy_file "time_formats.rb", "config/initializers/time_formats.rb"

say "Setting up a root route"

route "root :to => 'Clearance::Sessions#new'"

say "Congratulations! You just pulled our suspenders."
say "Remember to run 'rails generate hoptoad' with your API key."

