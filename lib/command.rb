# Methods needed to run a command.

module Suspenders
  module Command
    def run(cmd)
      puts "Running '#{cmd}'"
      out = `#{cmd}`
      fail "Command #{cmd} failed: #$?\n#{out}" if $? != 0
      out
    end
  end
end
