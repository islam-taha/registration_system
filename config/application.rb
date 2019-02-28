require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module RegistrationSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2


    unless Rails.env.test?
      log_level              = String(ENV['LOG_LEVEL'] || "info").upcase
      config.logger          = Logger.new(STDOUT)
      config.logger.level    = Logger.const_get(log_level)
      config.log_level       = log_level
      config.lograge.enabled = true
    end
  end
end
