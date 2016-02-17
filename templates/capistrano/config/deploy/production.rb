set :stage, :production
set :rails_env, :production

role :app, fetch(:deploy_target)
role :web, fetch(:deploy_target)
role :db,  fetch(:deploy_target)
