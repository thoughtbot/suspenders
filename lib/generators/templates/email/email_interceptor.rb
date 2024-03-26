class EmailInterceptor
  include ActiveSupport::Configurable

  config_accessor :interceptor_addresses, default: []

  def self.delivering_email(message)
    to = interceptor_addresses

    message.to = to if to.any?
  end
end
