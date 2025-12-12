# frozen_string_literal: true

require_relative "suspenders/version"
require_relative "suspenders/cli"
require_relative "suspenders/actions/test/raise_i18n_error"

module Suspenders
  class Error < StandardError; end
  # Your code goes here...
end
