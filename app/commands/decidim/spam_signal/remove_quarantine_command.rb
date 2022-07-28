# frozen_string_literal: true

module Decidim
  module SpamSignal
    ##
    # Decidim::SpamSignal::QuarantineCommand.call(suspicious_user, admin_reporter)
    class RemoveQuarantineCommand < ::Rectify::Command
      attr_accessor :suspicious_user,
        :admin_reporter

      def initialize(banned_user_report)
        @banned_user_report = banned_user_report
        @suspicious_user = banned_user_report.banned_user
        @admin_reporter = banned_user_report.admin_reporter
      end

      def call
        # The spam cop need to leave traces, so :
        # 1. Remove blockings and put back visibility on resources
        # 2. Remove the quarantine entry

        un_block!
        remove_quarantine!
      end
        private

          def un_block!
            # Un block the User
            Decidim::Admin::UnblockUser.call(suspicious_user, admin_reporter)
            # Block the comment he posted
            suspicious_comments.each do |spam|
              Decidim::Admin::UnhideResource.call(spam, admin_reporter)
            end
        end

          def remove_quarantine!
            @banned_user_report.destroy
          end

          def suspicious_comments
            @suspicious_comments ||= Decidim::Comments::Comment.where(author: suspicious_user)
          end
    end
  end
end
