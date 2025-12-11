# Methods like `copy_file` will accept relative paths to the template's location.
def source_paths
  Array(super) + [__dir__]
end

def install_gems
end

install_gems

after_bundle do
  # Finalization
  run_migrations
  lint_codebase

  print_message
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
