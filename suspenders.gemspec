require_relative "lib/suspenders/version"

Gem::Specification.new do |spec|
  spec.name = "suspenders"
  spec.version = Suspenders::VERSION
  spec.required_ruby_version = Suspenders::MINIMUM_RUBY_VERSION
  spec.authors = ["thoughtbot"]
  spec.email = ["support@thoughtbot.com"]
  spec.homepage = "http://github.com/thoughtbot/suspenders"
  spec.summary = "Rails generators using thoughtbot's best practices."
  spec.description = <<~HERE
    Suspenders is a Rails plugin containing generators for configuring Rails
    applications. It is used by thoughtbot to get a jump start on a new or
    existing app. Use Suspenders if you're in a rush to build something amazing;
    don't use it if you like missing deadlines.
  HERE

  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/thoughtbot/suspenders/blob/main/NEWS.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", Suspenders::RAILS_VERSION

  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "standard"
end
