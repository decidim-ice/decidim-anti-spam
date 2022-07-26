# frozen_string_literal: true

module Decidim
  module SpamSignal
    class BannedUser < ApplicationRecord
      self.table_name = "decidim_banned_users"
      belongs_to :banned_user, class_name: "Decidim::User"
      belongs_to :admin_reporter, class_name: "Decidim::User"

      validates :banned_user, presence: true
      validates :admin_reporter, presence: true
      scope :banned_users, -> { where.not(removed_at: nil) }
      scope :quarantine_users, -> { where.not(notified_at: nil) }

      def banned?
        removed_at?
      end

      def quarantine?
        !banned? && notified_at?
      end
    end
  end
end
