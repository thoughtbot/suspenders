# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'voyage/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Voyage::RUBY_VERSION}"
  s.authors = ['thoughtbot, headway']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Voyage is a fork of the suspenders base Rails project from thoughtbot. It
is used by headway to get a jump start on a working app.
  HERE

  s.email = 'development@headway.io'
  s.executables = ['voyage']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/headwayio/suspenders'
  s.license = 'MIT'
  s.name = 'voyage'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using headway's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Voyage::VERSION

  s.add_dependency 'bitters', '~> 1.5'
  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', Voyage::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.2'
end
