RSpec.configure do |config|
  config.around(:each, type: :view, allow_view_stub: true) do |example|
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = false
      example.run
      mocks.verify_partial_doubles = true
    end
  end
end
