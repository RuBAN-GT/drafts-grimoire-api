Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => Rails.application.secrets.email['address'],
    :port => Rails.application.secrets.email['port'],
    :authentication => :plain,
    :enable_starttls_auto => true,
    :tls => true,
    :user_name =>  Rails.application.secrets.email['user_name'],
    :password => Rails.application.secrets.email['password']
  }
  config.action_mailer.raise_delivery_errors = false

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  config.active_support.deprecation = :notify

  config.log_level = :warn
  config.log_tags = [ :request_id ]
  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.relative_url_root = '/rasputin'

  config.x.report_to = %w(darico3000@gmail.com randolph.o.webb@gmail.com)
  config.x.report_from = Rails.application.secrets.email['user_name']
  config.x.main_domain = 'grimoire.destiny.community'

  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'grimoire.destiny.community'
      resource '*',
        :headers => :any,
        :expose  => %w(Authorization),
        :credentials => true,
        :methods => %w(get post put patch delete)
    end
  end
end
