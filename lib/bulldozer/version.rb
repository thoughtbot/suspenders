module Bulldozer
  RAILS_VERSION = "~> 5.2.0".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "1.50.0".freeze
end
