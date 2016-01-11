require 'bundler/setup'
::Bundler.require(:default, :test)
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
