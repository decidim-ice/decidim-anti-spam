# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class SinalizeCopCommand < CopHandler
        def self.form
          ::Decidim::SpamSignal::Cops::SinalizeSettingsForm
        end

        def call
          errors.add(
            :body,
            I18n.t("errors.spam",
              scope: "decidim.spam_signal",
              default: "this looks like spam."
            )
          ) if config['forbid_creation_enabled']
          sinalize!
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
      end
    end
  end
end
