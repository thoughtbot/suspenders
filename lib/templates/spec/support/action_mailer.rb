RSpec.configure do |config|
  # https://guides.rubyonrails.org/testing.html#the-basic-test-case
  #
  # The ActionMailer::Base.deliveries array is only reset automatically in
  # ActionMailer::TestCase and ActionDispatch::IntegrationTest tests. If
  # you want to have a clean slate outside these test cases, you can reset
  # it manually with: ActionMailer::Base.deliveries.clear
  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end
end
