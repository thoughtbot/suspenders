RSpec.configure do |config|
  config.before(:each, type: :generator) do
    remove_project_directory
  end
end
