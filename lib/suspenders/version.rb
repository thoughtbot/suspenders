module Suspenders
  RAILS_VERSION = "~> 7.0.0".freeze

  minimum_ruby_version = "3.0.5"
  maximum_ruby_version = Pathname(__dir__).join("../../.ruby-version").read.strip

  RUBY_VERSION_RANGE = [minimum_ruby_version, maximum_ruby_version].freeze
  VERSION = "20230113.0".freeze
end
