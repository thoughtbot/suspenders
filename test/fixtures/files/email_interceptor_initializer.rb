Rails.application.configure do
  if ENV["INTERCEPTOR_ADDRESSES"].present?
    config.action_mailer.interceptors = %w[EmailInterceptor]
  end
end
