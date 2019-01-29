source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# main
gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'passenger'
gem 'redis', '~> 3.3'
gem 'redis-rails', '~> 5.0'
gem 'cancancan', '~> 1.10'
gem 'rack-cors', '~> 0.4.1'
gem 'kaminari'

# auth
gem 'jwt', '~> 1.5.6'

# langs
gem 'russian'
gem 'devise-i18n', '~> 1.1'
gem 'globalize', '~> 5.0', :github => 'globalize/globalize'
gem 'globalize-accessors'

# files
gem 'rmagick', '~> 2.16'
gem 'carrierwave', '~> 1.0'

# system
gem 'rails_admin', '~> 1.1.1'
gem 'hashie', '~> 3.5'
gem 'utf8-cleaner'
gem 'bcrypt', '~> 3.1'
gem 'non-stupid-digest-assets'
gem 'seed_dump'

# console
gem 'pry'
gem 'pry-rails'
gem 'pry-stack_explorer'

# api
gem 'active_model_serializers', '~> 0.10.0'
gem 'bungie_client', '~> 2.1.2.1'
gem 'twitter', '~> 6.1'

# cron
gem 'whenever', '~> 0.9'

# other
gem 'sitemap_generator', '~> 5.3.0'

group :development, :test do
  # data
  gem 'seedbank'
  gem 'faker'

  # factories
  gem 'factory_girl'
  gem 'factory_girl_rails'

  # productivity
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rails'
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'webmock', '~> 3.0'
  gem 'database_cleaner'
end

group :development do
  gem 'colorize'
  gem 'web-console'
  gem 'listen', '~> 3.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'byebug'
  gem 'pry-byebug'

  # deployment
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2'

  # development
  gem 'i18n_yaml_sorter'
  gem 'meta_request'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
