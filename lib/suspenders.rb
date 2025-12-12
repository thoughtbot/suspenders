# frozen_string_literal: true

require_relative "suspenders/version"
require_relative "suspenders/cli"
require_relative "suspenders/actions/test/raise_i18n_error"
require_relative "suspenders/actions/test/disable_show_dispatch_exception"

module Suspenders
  class Error < StandardError; end
  # Your code goes here...
end
