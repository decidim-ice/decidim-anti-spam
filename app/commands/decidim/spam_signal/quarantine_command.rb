module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCommand.call(banned_user, admin_reporter)
    module QuarantineCommand < Decidim::Command
      
      attr_accessor :banned_user, 
        :admin_reporter

      def initialize(banned_user, admin_reporter)
        @banned_user = banned_user
        @admin_reporter = admin_reporter
      end

      def call
        # Block user
      end
    end
  end
end