module Suspenders
  RAILS_VERSION = "~> 7.0.0".freeze
  RUBY_VERSION = IO
    .read("#{File.dirname(__FILE__)}/../../.ruby-version")
    .strip
    .freeze
  VERSION = "1.56.1".freeze
end
