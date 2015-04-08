require "yaml"

module Suspenders
  RAILS_VERSION = "4.2.1"
  MINIMUM_RUBY_VERSION = "2.0.0"
  travis_yml = File.open("#{File.dirname(__FILE__)}/../../.travis.yml")
  LATEST_RUBY_VERSION = YAML.load(travis_yml)["rvm"]
  VERSION = "1.27.0"
end
