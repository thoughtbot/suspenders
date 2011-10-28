Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name    = 'suspenders'
  s.version = '0.3.1'
  s.date    = '2011-10-28'

  s.summary     = "Generate a Rails app using thoughtbot's best practices."
  s.description = <<-HERE
Suspenders is a base Rails project that you can upgrade. It is used by
thoughtbot to get a jump start on a working app. Use Suspenders if you're in a
rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.authors  = ["thoughtbot"]
  s.email    = 'support@thoughtbot.com'
  s.homepage = 'http://github.com/thoughtbot/suspenders'

  s.executables = ["suspenders"]
  s.default_executable = 'suspenders'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('rails', '3.1.1')
  s.add_dependency('bundler', '>= 1.0.7')
  s.add_development_dependency('cucumber', '~> 1.1.0')
  s.add_development_dependency('aruba', '~> 0.4.6')

  # = MANIFEST =
  s.files = %w[
    CONTRIBUTING.md
    Gemfile
    Gemfile.lock
    LICENSE
    README.md
    Rakefile
    bin/suspenders
    features/rake_clean.feature
    features/step_definitions/shell.rb
    lib/suspenders/actions.rb
    lib/suspenders/app_builder.rb
    lib/suspenders/generators/app_generator.rb
    suspenders.gemspec
    templates/Gemfile_additions
    templates/Procfile
    templates/README_FOR_SUSPENDERS
    templates/_flashes.html.erb
    templates/_javascript.html.erb
    templates/errors.rb
    templates/factory_girl_steps.rb
    templates/import_scss_styles
    templates/javascripts/prefilled_input.js
    templates/postgresql_database.yml.erb
    templates/suspenders_gitignore
    templates/suspenders_layout.html.erb.erb
    templates/time_formats.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select {|path| path =~ /^features/ }
end
