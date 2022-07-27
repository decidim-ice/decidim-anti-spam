# frozen_string_literal: true

module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCleaningCommand.call
    class QuarantineCleaningCommand < ::Rectify::Command
      def call
        Decidim::SpamSignal::BannedUser.to_ban.each do |bannishment|
          bannishment.banned_user.destroy
          bannishment.update(removed_at: Time.current)
        end
      end
    end
  end
end
