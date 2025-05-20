# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class ForbiddenTldsSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm

        METADATA = {
          placeholder: I18n.t("placeholder", scope: "decidim.spam_signal.forms.forbidden_tlds_settings_form")
        }.freeze

        attribute :forbidden_tlds_csv, String
        validates :forbidden_tlds_csv, presence: true
      end
    end
  end
end
