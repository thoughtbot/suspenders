# :nocov:
module AnalyticsTrack
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/LineLength
  # Example Traditional Event: analytics_track(user, 'Created Widget', { widget_name: 'foo' })
  # Example Page View:         analytics_track(user, 'Page Viewed', { page_name: 'Terms and Conditions', url: '/terms' })
  #
  # NOTE: setup some defaults that we want to track on every event mixpanel_track
  # NOTE: the identify step happens on every page load to keep intercom.io and mixpanel people up to date
  # rubocop:enable Metrics/LineLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def analytics_track(user, event_name, options = {})
    return if user.tester?

    sanitized_options = sanitize_hash_javascript(options)

    # rubocop:disable Style/RescueModifier, Lint/RescueWithoutErrorClass
    segment_attributes = {
      user_id: user.uuid,
      event: event_name,
      properties: {
        browser: (browser.name rescue 'unknown'),
        browser_id: (browser.id rescue 'unknown'),
        browser_version: (browser.version rescue 'unknown'),
        platform: (browser.platform rescue 'unknown'),
        roles: (user.roles.map(&:to_s).join(',') rescue ''),
        rails_env: Rails.env.to_s,
      }.merge(sanitized_options),
    }
    # rubocop:enable Style/RescueModifier, Lint/RescueWithoutErrorClass
    # rubocop:enable Metrics/CyclomaticComplexity

    # TODO: Replace with whatever analytics that Connor wants
    # Analytics.track(segment_attributes)
    logger.debug('Analytics tracking info: ' + segment_attributes)
  end

  private

  def sanitize_hash_javascript(hash)
    hash.deep_stringify_keys
        .deep_transform_keys { |k| sanitize_javascript(k) }
        .transform_values    { |v| sanitize_javascript(v) }
  end

  def sanitize_javascript(value)
    value.is_a?(String) ? ActionView::Base.new.escape_javascript(value) : value
  end
end
# :nocov:
