lock '3.4.0'

def missing(name)
  @missing ||= []
  STDERR.puts "Plase set #{name} in deploy.rb"
end

set :github_user, lambda { missing('github_user') }
set :application, lambda { missing('application') }
set :deploy_root, lambda { missing('deploy_root') }
set :deploy_target, lambda { missing('deploy_target') }

raise "Please finish configuration" if @missing

set :ssh_options, { port: 22 }

set :linked_files, proc { ['config/database.yml', ".env.#{fetch(:rails_env)}"] }
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads data plugins)
set :repo_url, "git@github.com:#{fetch(:github_user)}/#{fetch(:application)}.git"
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, lambda { "#{fetch(:deploy_root)}/apps/#{fetch(:application)}/#{fetch(:stage)}" }
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_type, :user
set :rbenv_path, "#{fetch(:deploy_root)}/.rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :passenger_restart_with_touch, true
