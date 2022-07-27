# frozen_string_literal: true

module Decidim::SpamSignal::Admin
  module QuarantineHelper
    def report
      @report
    end
    def decidim
      Decidim::Core::Engine.routes.url_helpers
    end
    def decidim_comments
      Decidim::Comments::Engine.routes.url_helpers
    end
    def spammer_comments
      Decidim::Comments::Comment.where(author: spammer)
    end
    def spammer
      @report.banned_user
    end

    def spam_cop
      @report.admin_reporter
    end

    def next_report
      Decidim::SpamSignal::BannedUser.quarantine_users.order(
        notified_at: :asc
      ).where(
        "id > ?", @report.id
      ).first
    end
    def previous_report
      Decidim::SpamSignal::BannedUser.quarantine_users.order(
        notified_at: :asc
      ).where(
        "id < ?", @report.id
      ).first
    end
  end
end
