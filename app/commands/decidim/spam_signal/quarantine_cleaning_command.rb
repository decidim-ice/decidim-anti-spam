# frozen_string_literal: true

module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCleaningCommand.call
    class QuarantineCleaningCommand < ::Rectify::Command
      def call
        # Remove all user banned for more than x days
      end
    end
  end
end
