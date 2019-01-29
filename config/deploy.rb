set :application, 'grimoire-api'
set :repo_url, 'git@bitbucket.org:DetemiroTM/grimoire-api.git'
set :branch, (ENV['BRANCH'] || 'master')
set :log_level, :error

set :rails_env, 'production'
set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role)) }
set :conditionally_migrate, true
set :assets_roles, [:web, :app]
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :keep_assets, 2
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :migration_role, :app
