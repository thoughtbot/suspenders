module Suspenders
  RAILS_VERSION = "~> 7.0.0".freeze
  RUBY_VERSION = IO
    .read("#{File.dirname(__FILE__)}/../../.ruby-version")
    .strip
    .freeze
  VERSION = "20230113.0".freeze
end
