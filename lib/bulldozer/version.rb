module Bulldozer
  RAILS_VERSION = "~> 5.2.0".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "1.6.0".freeze
end
