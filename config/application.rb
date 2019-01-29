require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Grimoire
  class Application < Rails::Application
    VERSION = 0.9

    # api mode
    config.api_only = true

    # libs
    config.eager_load_paths += Dir["#{config.root}/lib/"]

    # cache
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    # i18n
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.fallbacks = [:en]

    # middleware
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # other settings
    config.x.report_to = []
  end
end
