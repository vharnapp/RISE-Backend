module AnalyticsTrack
  extend ActiveSupport::Concern

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

  def sanitize_hash_javascript(hash)
    hash.deep_stringify_keys
      .deep_transform_keys { |k| sanitize_javascript(k) }
      .transform_values    { |v| sanitize_javascript(v) }
  end

  def sanitize_javascript(value)
    value.is_a?(String) ? ActionView::Base.new.escape_javascript(value) : value
  end
end
