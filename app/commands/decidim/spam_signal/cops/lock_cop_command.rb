# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class LockCopCommand < CopHandler
        def self.form
          nil
        end

        def call
          sinalize!
          lock!
          broadcast(:ok)
        end

        private
          def sinalize!
            moderation = Decidim::UserModeration.find_or_create_by!(user: suspicious_user)
            Decidim::UserReport.find_or_create_by!(moderation: moderation)  do |report|
              report.moderation = moderation
              report.user = admin_reporter
              report.reason = "spam"
              report.details = I18n.t("decidim.spam_signal.spam_signal_justification")
            end
          end

          def lock!
            suspicious_user.lock
          end
      end
    end
  end
end
