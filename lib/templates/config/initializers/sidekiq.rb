# https://github.com/sidekiq/sidekiq/wiki/Heroku

SIDEKIQ_REDIS_CONFIGURATION = {
  url: ENV.fetch(ENV.fetch("REDIS_PROVIDER", "REDIS_URL"), nil), # use REDIS_PROVIDER for Redis environment variable name, defaulting to REDIS_URL
  ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE} # we must trust Heroku and AWS here
}

Sidekiq.configure_server do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end

Sidekiq.configure_client do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end
