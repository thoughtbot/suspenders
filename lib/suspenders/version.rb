module Suspenders
  RAILS_VERSION = "~> 5.1.3".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "1.44.0".freeze
end
