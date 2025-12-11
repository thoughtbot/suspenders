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

  # Deployment
  add_procfiles

  # Environments
  setup_test_environment

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

def add_procfiles
  copy_file "Procfile"
end

def setup_test_environment
  uncomment_lines(
    "config/environments/test.rb",
    /config\.i18n\.raise_on_missing_translations\s*=\s*true/
  )
  comment_lines(
    "config/environments/test.rb",
    /config\.action_dispatch\.show_exceptions\s=\s:rescuable/
  )
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
