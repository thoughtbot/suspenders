Mail.register_interceptor(
  RecipientInterceptor.new(ENV.fetch("EMAIL_RECIPIENTS"))
)
