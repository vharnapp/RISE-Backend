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

    config.active_job.queue_adapter = :delayed_job

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        s3_region: ENV['AWS_REGION'],
        s3_host_name: "s3-#{ENV['AWS_REGION']}.amazonaws.com",
      },
    }
  end
end
