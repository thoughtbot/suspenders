require "pathname"

class MessageMatcher
  def initialize(message:, &block)
    @method, @args = message
    @args ||= []
    @block = block || raise("Needs a block!")
  end

  def method_missing(method, *args, &block)
    if method == @method && args == @args
      @block.call
    else
      puts "Failed to match! Method: #{method}, args: #{args}"
    end
  end

  def respond_to_missing?(method, include_private = false)
    method == @method
  end
end
