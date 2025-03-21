namespace :development do
  desc "Loads seed data into development."
  task seed: :environment do
    Seeder.load_seeds
  end

  namespace :seed do
    desc "Truncate tables of each database in development and loads seed data."
    task replant: ["environment", "db:truncate_all", "development:seed"]
  end
end
