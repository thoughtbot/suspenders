if Rails.env.development? || Rails.env.test?
  require "factory_bot" if Bundler.rubygems.find_name("factory_bot_rails").any?

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryBot::Syntax::Methods if Bundler.rubygems.find_name("factory_bot_rails").any?

      # create(:user, email: "user@example.com", password: "password")
    end
  end
end
