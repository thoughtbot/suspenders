require "suspenders/version"
require "suspenders/engine"
require "suspenders/railtie"
require "suspenders/generators"
require "suspenders/cleanup/organize_gemfile"
require "suspenders/cleanup/generate_readme"
require "suspenders/cli"

module Suspenders
  class Error < StandardError; end
end
