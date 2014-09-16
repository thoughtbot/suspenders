if Rails.env.development?
  namespace :dev do
    desc "Seed data for development environment"
    task prime: ["db:setup", "db:seed"]
  end
end
