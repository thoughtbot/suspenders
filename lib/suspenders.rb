# frozen_string_literal: true

require_relative "suspenders/version"
require_relative "suspenders/cli"
require_relative "suspenders/actions/environments/test/raise_on_missing_translations"

module Suspenders
  class Error < StandardError; end
  # Your code goes here...
end
