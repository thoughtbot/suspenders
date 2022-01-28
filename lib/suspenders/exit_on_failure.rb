require "active_support/concern"
require "English"

module Suspenders
  module ExitOnFailure
    extend ActiveSupport::Concern

    def bundle_command(*)
      super
      exit(false) if $CHILD_STATUS.exitstatus.nonzero?
    end

    module ClassMethods
      def exit_on_failure?
        true
      end
    end
  end
end
