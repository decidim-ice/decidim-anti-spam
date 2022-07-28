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
          QuarantineCommand.call(
            self,
            SpamCopService.get(organization),
            about
          )
        end

        def about_valid?
          about.empty? || SpamDetectionService.instance(config).valid?(about)
        end

        def config
          Config.get_config(organization)
        end
      end
    end
  end
end
