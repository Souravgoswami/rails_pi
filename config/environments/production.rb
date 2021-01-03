Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.assets.precompile += %w( bootstrap.scss )
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end
