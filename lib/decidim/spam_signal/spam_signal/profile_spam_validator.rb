# frozen_string_literal: true

module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :spam_signal_about_validation, on: :update, if: :about_changed?
        def spam_signal_about_validation
          return if about_valid?
          errors.add(:about, I18n.t("decidim.spam_signal.errors.spam"))
          Decidim::SpamSignal::QuarantineCommand.call(
            self,
            Decidim::SpamSignal::SpamCopService.get(organization)
          )
        end

        def about_valid?
          about.empty? || Decidim::SpamSignal::SpamDetectionService.valid?(about)
        end
      end
    end
  end
end
