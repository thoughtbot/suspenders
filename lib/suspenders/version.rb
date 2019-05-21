module Suspenders
  RAILS_VERSION = "~> 5.2.3".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "1.51.0".freeze
end
