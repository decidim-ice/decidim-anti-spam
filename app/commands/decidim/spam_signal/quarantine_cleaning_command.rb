module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCleaningCommand.call
    module QuarantineCleaningCommand < Decidim::Command
      def call
        # Remove all user banned for more than x days
      end
    end
  end
end