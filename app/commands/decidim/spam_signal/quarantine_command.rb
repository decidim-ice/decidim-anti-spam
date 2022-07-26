# frozen_string_literal: true

module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCommand.call(banned_user, admin_reporter)
    class QuarantineCommand < ::Rectify::Command
      attr_accessor :banned_user,
        :admin_reporter

      def initialize(banned_user, admin_reporter)
        @banned_user = banned_user
        @admin_reporter = admin_reporter
      end

      def call
        # The spam cop need to leave traces, so :
        # 1. Sinalize the user
        # 2. Block it, (user will receive a notification)
        # 3. Put him in quarantine. (user will receive a notification)

        sinalize!
        block!
        quarantine!
      end

      private
        def sinalize!
          moderation = Decidim::UserModeration.find_or_create_by!(user: banned_user)
          Decidim::UserReport.create!(
            moderation: moderation,
            user: admin_reporter,
            reason: "spam",
            details: "Spam Filter reported abuse of the plateform Uses and Conditions."
          )
        end

        def block!
          Decidim::Admin::BlockUser.call(
            Decidim::Admin::BlockUserForm.from_params({
              justification: "Spam Filter blocked the user according the platform's Uses and Conditions.",
              user_id: banned_user.id
            }).with_context(
              current_organization: banned_user.organization,
              current_user: admin_reporter
            )
          )
          banned_user.update!(blocked_at: DateTime.now)
      end

        def quarantine!
          Decidim::SpamSignal::BannedUser.create!(
            notified_at: DateTime.now,
            banned_user: banned_user,
            admin_reporter: admin_reporter
          )
        end
    end
  end
end
