require "active_job/logging"
require "active_job/log_subscriber"

ActiveSupport::Notifications.unsubscribe("enqueue.active_job")

module ActiveJob
  module Logging
    class EnqueueLogSubscriber < LogSubscriber
      define_method :enqueue, instance_method(:enqueue)
    end
  end
end

ActiveJob::Logging::EnqueueLogSubscriber.attach_to(:active_job)
