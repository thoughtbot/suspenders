Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name    = 'suspenders'
  s.version = '0.2.5'
  s.date    = '2011-06-01'

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

  s.add_dependency('rails', '3.0.9')
  s.add_dependency('bundler', '>= 1.0.7')
  s.add_dependency('trout', '>= 0.3.0')
  s.add_development_dependancy('cucumber', '~> 1.0.2')

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.md
    Rakefile
    bin/suspenders
    features/rake_clean.feature
    features/step_definitions/shell.rb
    features/support/env.rb
    lib/create.rb
    lib/errors.rb
    suspenders.gemspec
    template/files/README_FOR_SUSPENDERS
    template/files/_flashes.html.erb
    template/files/_javascript.html.erb
    template/files/body_class_helper.rb
    template/files/errors.rb
    template/files/factory_girl_steps.rb
    template/files/postgresql_database.yml.erb
    template/files/suspenders_gitignore
    template/files/suspenders_layout.html.erb.erb
    template/files/time_formats.rb
    template/suspenders.rb
    template/trout/Gemfile
    template/trout/public/javascripts/prefilled_input.js
  ]
  # = MANIFEST =

  s.test_files = s.files.select {|path| path =~ /^features/ }
end
