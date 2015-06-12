RSpec.configure do |config|
  config.around(:each, type: :helper) do |example|
    config.mock_with :rspec do |mocks|
      cached_double_verification = mocks.verify_partial_doubles?
      mocks.verify_partial_doubles = false

      example.run

      mocks.verify_partial_doubles = cached_double_verification
    end
  end
end
