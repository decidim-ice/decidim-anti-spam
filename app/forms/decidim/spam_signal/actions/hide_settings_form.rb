# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class HideSettingsForm < ActionSettingsForm

        translatable_attribute :hide_forbiden_page_message, String
        attribute :hide_enabled, Boolean, default: true
        translatable_attribute :hide_message, String
        validate :message_present_if_enabled
        validate :forbidden_page_message_present

        add_conditional_display(:hide_message, :hide_enabled)

        private

        def forbidden_page_message_present
          hide_forbiden_page_message.each do |key, val|
            errors.add(:"hide_forbiden_page_message_#{normalize_locale(key)}", :blank) if val.blank?
          end
        end

        def message_present_if_enabled
          return unless hide_enabled

          hide_message.each do |key, val|
            errors.add(:"hide_message_#{normalize_locale(key)}", :blank) if val.blank?
          end
        end
      end
    end
  end
end
