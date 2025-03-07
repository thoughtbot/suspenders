abort "Seeds can only be loaded in the development environment" unless Rails.env.development?

require "factory_bot"

class Seeder
  include FactoryBot::Syntax::Methods

  def self.load_seeds
    new.load_seeds
  end

  def load_seeds
    # The code here should be idempotent so that it can be executed at any point in development.
    #
    # Example:
    #
    #   emails = %w[ralph@example.com ruby@example.com]
    #
    #   emails.each do |email|
    #     create(:user, email:) unless User.exists?(email:)
    #   end
  end
end
