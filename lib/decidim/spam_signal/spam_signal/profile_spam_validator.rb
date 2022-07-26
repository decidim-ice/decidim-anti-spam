module Decidim
  module SpamSignal
    module ProfileSpamValidator
      extend ActiveSupport::Concern

      included do
        validate :demo, on: :update, if: :about_changed?

        def demo
          return if about_valid?(about)
          errors.add(:about, I18n.t("decidim.spam_signal.errors.spam"))
          self.update!(blocked_at: DateTime.now)
        end
        def about_valid?
          about.present?
        end
      end
    end
  end
end