# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization unless: :devise_or_pages_controller?
  impersonates :user
  acts_as_token_authentication_handler_for User

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: -> { is_a?(HighVoltage::PagesController) }
  before_action :add_layout_name_to_gon
  before_action :detect_device_type

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  # Example Traditional Event: analytics_track(user, 'Created Widget', { widget_name: 'foo' })
  # Example Page View:         analytics_track(user, 'Page Viewed', { page_name: 'Terms and Conditions', url: '/terms' })
  #
  # NOTE: setup some defaults that we want to track on every event mixpanel_track
  # NOTE: the identify step happens on every page load to keep intercom.io and mixpanel people up to date
  def analytics_track(user, event_name, options = {})
    return if user.tester?

    sanitized_options = sanitize_hash_javascript(options)

    segment_attributes = {
      user_id: user.uuid,
      event: event_name,
      properties: {
        browser:         (begin
                              browser.name
                            rescue
                              'unknown'
                            end).to_s,
        browser_id:      (begin
                              browser.id
                            rescue
                              'unknown'
                            end).to_s,
        browser_version: (begin
                              browser.version
                            rescue
                              'unknown'
                            end).to_s,
        platform:        (begin
                              browser.platform
                            rescue
                              'unknown'
                            end).to_s,
        roles:           (begin
                              user.roles.map(&:to_s).join(',')
                            rescue
                              ''
                            end).to_s,
        rails_env:       Rails.env.to_s,
      }.merge(sanitized_options),
    }

    Analytics.track(segment_attributes)
  end

  protected

  def devise_or_pages_controller?
    devise_controller? == true || is_a?(HighVoltage::PagesController)
  end

  def sanitize_hash_javascript(hash)
    hash.deep_stringify_keys
        .deep_transform_keys { |k| sanitize_javascript(k) }
        .transform_values    { |v| sanitize_javascript(v) }
  end

  def sanitize_javascript(value)
    value.is_a?(String) ? ActionView::Base.new.escape_javascript(value) : value
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[
        first_name
        last_name
        email
        password
        password_confirmation
        remember_me
      ],
    )

    devise_parameter_sanitizer.permit(
      :sign_in,
      keys: %i[
        login email password remember_me
      ],
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[
        first_name
        last_name
        email
        password
        password_confirmation
        current_password
      ],
    )
  end

  def add_layout_name_to_gon
    gon.layout =
      case devise_controller?
      when true
        'devise'
      else
        'application'
      end
  end

  def detect_device_type
    request.variant =
      case request.user_agent
      when /iPad/i
        :tablet
      when /iPhone/i
        :phone
      when /Android/i && /mobile/i
        :phone
      when /Android/i
        :tablet
      when /Windows Phone/i
        :phone
      end
  end
end
