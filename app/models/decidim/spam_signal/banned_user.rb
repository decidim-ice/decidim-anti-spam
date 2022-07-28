# frozen_string_literal: true

module Decidim
  module SpamSignal
    class BannedUser < ApplicationRecord
      self.table_name = "decidim_banned_users"
      belongs_to :banned_user, class_name: "Decidim::User"

      belongs_to :admin_reporter, class_name: "Decidim::User"
      before_create :set_email
      validates :banned_user, presence: true, on: :create
      validates :admin_reporter, presence: true
      scope :banned_users, -> { where.not(removed_at: nil) }
      scope :quarantine_users, -> { where(removed_at: nil).where.not(notified_at: nil) }
      scope :to_ban, -> { quarantine_users.where("notified_at < ?", (Decidim::SpamSignal.config.days_before_delete + 1.minute).ago) }

      def banned?
        removed_at?
      end



      def quarantine?
        !banned? && notified_at?
      end

      private
        def set_email
          self.banned_email = banned_user.email
        end
    end
  end
end
