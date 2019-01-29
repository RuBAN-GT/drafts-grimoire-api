namespace :redis do
  desc 'Flushes all Redis data'
  task :flushall do
    on roles(:app) do
      execute 'redis-cli flushall'
    end
  end
end

after 'deploy:fix_permissions', 'redis:flushall'
