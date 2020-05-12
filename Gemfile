# rubocop:disable Metrics/LineLength
source 'https://rubygems.org'

ruby '2.5.1'
# ruby-gemset=athletefit_backend

gem 'autoprefixer-rails'

gem 'flutie'
gem 'honeybadger'
gem 'jquery-rails'
gem 'normalize-rails', '~> 3.0.0'
gem 'pg'
gem 'rack-canonical-host'
gem 'rails', '~> 5.1.1'
gem 'recipient_interceptor'
# gem 'sass-rails', '~> 5.0'
gem 'sassc-rails'
gem 'simple_form'
# gem 'skylight'
gem 'rollbar'
gem 'sprockets', '>= 3.0.0'
gem 'title'
gem 'uglifier'
gem 'voyage'
# gem 'webpacker', github: 'rails/webpacker'
gem 'rack-cors', require: 'rack/cors'

# Customizations
gem 'font-awesome-rails'
gem 'foundation-rails', '~> 6.3.1'
gem 'slim-rails'
gem 'bootsnap', require: false
gem 'trix'

gem 'acts_as_list'
gem 'administrate', github: 'headwayio/administrate', branch: 'feature/custom_sorting_via_options'#, path: '/rails/headway/administrate_gems/administrate'
gem 'administrate-field-carrierwave', '~> 0.2.0'
gem 'administrate-field-collection_select'
gem 'administrate-field-enum', github: 'headwayio/administrate-field-enum'
gem 'administrate-field-nested_has_many', github: 'headwayio/administrate-field-nested_has_many', branch: 'rails_5'
gem 'administrate-field-paperclip'
gem 'administrate-field-password'
gem 'administrate-field-select_essential'
# gem 'require_reloader', github: 'teohm/require_reloader' # Doesn't work well with the administrate dependent gems :/

gem 'validates_overlap', github: 'robinbortlik/validates_overlap'

gem 'aws-sdk', '~> 2.9'
gem 'paperclip'
gem 'paperclip-av-transcoder'

# Javascript Tweaks
gem 'gon' # pass variables betwween rails and javascript. Several examples in the application_controller.rb
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'nprogress-rails' # Show request progress when a link is clicked
gem 'responders' # respond to json/html/js more easily in controllers
gem 'turbolinks'

# Authentication / Authorization
gem 'canard', git: 'https://github.com/jondkinney/canard.git', branch: 'feature/fixed-generators-and-rails-5' # ties into cancancan, adds roles for the user
gem 'cancancan' # authorization library
gem 'devise'
gem 'devise_invitable'
gem 'jsonapi-utils', '~> 0.6.0.beta'
gem 'pretender' # impersonate users as an admin
gem 'tiddle' # token based authentication

# Database Tweaks
gem 'active_model_serializers', '~> 0.10.0'
gem 'dynamic_form' # for custom messages without the database column
gem 'friendly_id' # slugs in the url auto-generated
gem 'nested_form_fields' # Dynamically add and remove nested has_many association fields in a Ruby on Rails form
# gem 'nondestructive_migrations' # data migrations go here, not in regular ActiveRecord migrations
gem 'nondestructive_migrations', git: 'https://github.com/mfazekas/nondestructive_migrations.git', branch: 'fix-orm-warning'
gem 'paranoia' # soft-delete
gem 'settingslogic' # yaml settings (project wide, non-editable), this is implemented with the model Settings.rb

# User Uploads
gem 'carrierwave'
gem 'carrier_wave_base64_uploader', git: 'https://github.com/headwayio/carrier_wave_base64_uploader'
gem 'fog'
gem 'mini_magick'

# Cron Jobs
gem 'whenever', require: false # provides a clear syntax for writing and deploying cron jobs
gem 'whenever-web'

# Payment
gem 'stripe-rails'

# Debugging (need at top level if we want pry-remote to work on a deployed prod server)
gem 'pry-awesome_print' # make pry output legible
gem 'pry-byebug' # stepwise debugging inside pry
gem 'pry-rails' # better REPL than irb
gem 'pry-remote' # Production debugging

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'

  # Customizations
  gem 'annotate' # annotate models automatically when rake db:migrate is called
  # gem 'better_errors' # A better error page for rails when a local 500 (or similar) is thrown
  # gem 'binding_of_caller' # REPL in better_errors to debug in the browser at the point at which it failed
  gem 'fix-db-schema-conflicts' # when working with multiple developers schema order of columns is standardized.
  gem 'meta_request' # for chrome rails console plugin found here: https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg?hl=en-US
  gem 'rails-erd' # auto gen ERD Diagram of models in the app on rake db:migrate
  gem 'zenflow', git: 'https://github.com/zencoder/zenflow.git'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.5'

  # Customizations
  gem 'airborne'
  gem 'letter_opener' # auto-open emails when they're sent
  gem 'redcarpet' # used to render the readme inside a static welcome page from the high_voltage gem
  gem 'rubocop'
  gem 'rubocop-rspec', require: false
end

group :development, :staging do
  gem 'rack-mini-profiler', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'

  # Customizations
  gem 'cadre' # highlights code coverage in vim
  gem 'capybara' # DSL for finding elements on a page during integration testing
  gem 'json-schema' # Allows testing API responses against JSON schema
  gem 'poltergeist' # Headless browser, used in integration tests
  gem 'rspec_junit_formatter' # Creates JUnit style XML for use in CircleCI
  gem 'selenium-webdriver' # `brew install chromedriver`, used for acceptance tests in an actual browser.
end

group :development, :test, :staging do
  gem 'factory_girl_rails'
  gem 'faker' # provides auto generated names for factories, can be customized
end

group :staging, :production do
  # gem 'rack-timeout'
  gem 'newrelic_rpm'
end

group :production do
  gem 'analytics-ruby', '~> 2.2.2', require: 'segment/analytics'
  gem 'puma'
end

gem 'high_voltage'
gem 'newrelic_rpm'
