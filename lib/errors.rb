# User errors

module Suspenders
  class InvalidInput < Exception; end

  module Errors
    def error_with_message(msg)
      STDERR.puts msg
      exit 1
    end
  end
end
