require "pathname"

load Pathname(__dir__).join("..", "..", "..", "support", "message_matcher.rb")

module Bundler
  module Audit
    Task = MessageMatcher.new(message: [:new]) do
      puts "Fake task loaded"
    end
  end
end
