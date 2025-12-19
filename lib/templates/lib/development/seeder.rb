# This file should ensure the existence of records required to run the application in development.
# The code here should be idempotent so that it can be executed at any point in development.
# The data can then be loaded with the bin/rails development:db:seed command.

module Development
  class Seeder
    def self.load_seeds
      if Rails.env.development?
        new.load_seeds
      else
        raise "Development::Seeder can only be run in a development environment."
      end
    end

    def load_seeds
      #   ["Ruby", "Ralph"].each do |name|
      #     User.find_or_create_by!(name:)
      #   end
    end
  end
end
