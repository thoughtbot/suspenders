RSpec.configure do |config|
  config.before(:suite) do
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.include FactoryGirl::Syntax::Methods
end
