if Rails.env.development?
  namespace :development do
    namespace :db do
      desc "Loads seed data into development."
      task seed: ["environment", "db:seed"] do
        Development::Seeder.load_seeds
      end

      namespace :seed do
        desc "Truncate tables of each database for development and loads seed data."
        task replant: ["environment", "db:truncate_all", "development:db:seed"]
      end
    end
  end
end
