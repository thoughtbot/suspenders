if ENV.fetch("COVERAGE", false)
  require "simplecov"
  SimpleCov.start "rails"
end

require "webmock/rspec"

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.example_status_persistence_file_path = File.expand_path("../examples.txt", __FILE__)
end

WebMock.disable_net_connect!(allow_localhost: true)
