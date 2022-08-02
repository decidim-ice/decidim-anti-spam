# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class QuarantineSettingsForm < SettingsForm
        attribute :num_days_of_quarantine, Integer

        validate :valid_days_of_quarantine

        def valid_days_of_quarantine
          errors.add(
            :num_days_of_quarantine,
            I18n.t(
              "errors.num_days_of_quarantine",
              scope: "decidim.spam_signal.cops.quarantine_cop_command",
              default: "Days Before Delete should be positive"
            )
          ) unless num_days_of_quarantine.positive?
        end
      end
    end
  end
end
