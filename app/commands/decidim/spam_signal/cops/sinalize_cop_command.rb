# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class SinalizeCopCommand < CopHandler
        def self.form
          ::Decidim::SpamSignal::Cops::SinalizeSettingsForm
        end

        def call
          if config["forbid_creation_enabled"]
            errors.add(
              error_key,
              I18n.t("errors.spam",
                     scope: "decidim.spam_signal",
                     default: "this looks like spam.")
            )
          end
          sinalize!(is_user_reported: config["send_emails_enabled"])
          broadcast(config["forbid_creation_enabled"] ? :restore_value : :save)
        end
      end
    end
  end
end
