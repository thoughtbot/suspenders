release: bundle exec rails db:migrate; bundle exec rails db:seed
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 10
