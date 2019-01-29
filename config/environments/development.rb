Rails.application.configure do
  config.allow_concurrency = true
  config.cache_classes = false
  config.eager_load = false

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { :host => 'localhost', :port => 3000 }

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.debug_exception_response_format = :default

  config.x.report_to   = %w(dkruban@gmail.com)
  config.x.report_from = 'reports@localhost'
  config.x.main_domain = 'localhost:3333'

  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*',
        :headers => :any,
        :expose  => %w(Authorization),
        :credentials => true,
        :methods => %w(get post put patch delete)
    end
  end
end
