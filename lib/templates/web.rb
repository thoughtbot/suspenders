require_relative "suspenders/actions/test/raise_i18n_error"

# Methods like `copy_file` will accept relative paths to the template's location.
def source_paths
  Array(super) + [__dir__]
end

def install_gems
end

install_gems

after_bundle do
  # Initializers & Configuration
  configure_database

  # Test Environment
  configure_test_environment

  # Deployment
  add_procfiles

  # Finalization
  run_migrations
  lint_codebase

  print_message
end

def configure_database
  gsub_file "config/database.yml", /^production:.*?password:.*?\n/m, <<~YAML
    production:
      <<: *default
      url: <%= ENV["DATABASE_URL"] %>
  YAML
end

def configure_test_environment
  invoke Suspenders::Actions::Test::RaiseI18nError
end

def add_procfiles
  copy_file "Procfile"
end

def run_migrations
  rails_command "db:create"
  rails_command "db:migrate"
end

def lint_codebase
  run "bin/rubocop -a"
end

def print_message
  say "*" * 50
  say "Congratulations! You just pulled our suspenders."
  say "*" * 50
end
