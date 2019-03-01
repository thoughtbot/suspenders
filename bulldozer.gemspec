# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'bulldozer/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Bulldozer::RUBY_VERSION}"
  s.required_rubygems_version = ">= 2.7.4"
  s.authors = ['seasoned']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Bulldozer is a base Rails project that you can upgrade. It is used by
seasoned to get a jump start on a working app. Use Bulldozer if you're in a
rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.email = 'support@seasoned.cc'
  s.executables = ['bulldozer']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/SeasonedSoftware/bulldozer'
  s.license = 'MIT'
  s.name = 'bulldozer'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using seasoned's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Bulldozer::VERSION

  s.add_dependency 'bitters', '~> 1.7'
  s.add_dependency 'rails', Bulldozer::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.2'
end
