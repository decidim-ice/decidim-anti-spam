# frozen_string_literal: true

module Decidim
  module SpamSignal
    class QuarantineCopForm < StrategyForm
      attribute :num_days_of_quarantine, Integer
      attribute :is_automatic_banned, Integer

      validate :valid_days_of_quarantine

      def valid_days_of_quarantine
        errors.add(
          :num_days_of_quarantine,
          I18n.t(
            "errors.num_days_of_quarantine",
            scope: "decidim.spam_signal.cops.quarantine_cop_command",
            default: "Days Before Delete should be positive or -1 to disabled."
          )
        ) if num_days_of_quarantine.to_i < -1
      end
    end
  end
end
