# frozen_string_literal: true

module Decidim::SpamSignal::Admin
  module QuarantineHelper
    include ActionView::Helpers::DateHelper
    def days_to_ban
      distance_of_time_in_words_to_now(
        report.notified_at + Decidim::SpamSignal::Config.get_config.days_before_delete.days + 1.minute
      )
    end
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
