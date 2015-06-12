module ViewSpecHelpers
  def stub_current_user(as: nil)
    allow(view).to receive(:current_user).and_return(as)
  end
end

RSpec.configure do |config|
  config.include ViewSpecHelpers, type: :view

  config.around(:each, type: :view, allow_view_stub: true) do |example|
    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = false
      example.run
      mocks.verify_partial_doubles = true
    end
  end
end
