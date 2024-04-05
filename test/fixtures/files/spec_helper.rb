require "webmock/rspec"

RSpec.configure do |config|
  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [
    /(chromedriver|storage).googleapis.com/,
    "googlechromelabs.github.io"
  ]
)
