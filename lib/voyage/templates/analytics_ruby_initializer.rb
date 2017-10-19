if Rails.env.production?
  require 'segment/analytics'

  Analytics = Segment::Analytics.new(
    write_key: ENV['SEGMENT_ANALYTICS_RUBY_KEY'],
    on_error:  proc { |_status, msg| Rails.logger.info msg },
  )
else
  Analytics = Struct.new('Analytics') do
    def self.track(_segment_attributes)
    end
    def self.identify(_segment_attributes)
    end
  end
end
