# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ForbidSaveSettingsForm < ActionSettingsForm

        attribute :forbid_save_enabled, Boolean, default: true
        translatable_attribute :forbid_save_message, String
        validate :message_present_if_enabled
        add_conditional_display(:forbid_save_message, :forbid_save_enabled)

        private

        def message_present_if_enabled
          errors.add(:forbid_save_message, :blank) if forbid_save_enabled && forbid_save_message.blank?
        end
      end
    end
  end
end
