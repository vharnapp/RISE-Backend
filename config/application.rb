require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AthletefitBackend
  class Application < Rails::Application
    config.assets.quiet = true

    config.generators do |g|
      g.helper false
      g.javascript_engine false
      g.request_specs true
      g.controller_specs false
      g.routing_specs false
      g.stylesheets false
      g.test_framework :rspec
      g.view_specs false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :slim
    end

    config.action_controller.action_on_unpermitted_parameters = :raise
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.active_job.queue_adapter = :delayed_job

    config.paperclip_defaults = {
      storage: :filesystem,
    }

    config.time_zone = 'Central Time (US & Canada)'

    config.stripe.publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    config.to_prepare do
      Devise::SessionsController.layout 'no_header_or_footer'
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? 'application' : 'no_header_or_footer' }
      # Devise::ConfirmationsController.layout "devise"
      # Devise::UnlocksController.layout "devise"
      Devise::PasswordsController.layout 'no_header_or_footer'
    end
  end
end
