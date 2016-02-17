set :stage, :staging
set :rails_env, :staging

role :app, fetch(:deploy_target)
role :web, fetch(:deploy_target)
role :db,  fetch(:deploy_target)
