# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class AllowedTldsSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm

        attribute :allowed_tlds_csv, String
        validates :allowed_tlds_csv, presence: true
        METADATA = {
          placeholder: I18n.t("placeholder", scope: "decidim.spam_signal.forms.allowed_tlds_settings_form")
        }.freeze
      end
    end
  end
end
