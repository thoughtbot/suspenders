if ENV.include?('AIRBRAKE_API_KEY')
  Airbrake.configure do |config|
    config.api_key = ENV.fetch('AIRBRAKE_API_KEY')
  end
end
