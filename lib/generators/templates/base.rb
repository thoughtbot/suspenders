def source_paths
  Array(super) + [__dir__]
end

after_bundle do
  # Add suspenders gem
  gem_group :development, :test do
    gem "suspenders", path: File.expand_path("../../..", __dir__)
  end

  run "bundle install"

  # Run generators
  # This needs to go first, since it configures `.node-version`
  generate "suspenders:prerequisites"

  generate "suspenders:accessibility"
  generate "suspenders:email"
  generate "suspenders:factories"
  generate "suspenders:inline_svg"
  generate "suspenders:rake"
  generate "suspenders:setup"
  generate "suspenders:tasks"
  generate "suspenders:testing"
  generate "suspenders:views"
  generate "suspenders:jobs"

  # Needs to run after other generators, since some touch the
  # configuration files.
  generate "suspenders:environments:test"
  generate "suspenders:environments:development"
  generate "suspenders:environments:production"
end
