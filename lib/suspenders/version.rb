module Suspenders
  RAILS_VERSION = "~> 5.2.0".freeze
  RUBY_VERSION = IO.
    read("#{File.dirname(__FILE__)}/../../.ruby-version").
    strip.
    freeze
  VERSION = "1.46.0".freeze
end
