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
    Suspenders is intended to create a new Rails applications, and is optimized for deployment on Heroku.
    It is used by thoughtbot to get a jump start on new apps. Use Suspenders if you're in a rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/thoughtbot/suspenders/blob/main/NEWS.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
