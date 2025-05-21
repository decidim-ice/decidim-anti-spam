# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class ForbidSaveActionCommand < ActionCommand
        def call
          return broadcast(:save) unless config["forbid_save_enabled"]

          current_locale = suspicious_user.locale || current_organization.default_locale
          error_keys.each do |error_key|
            errors.add(
              error_key,
              :invalid
            )
          end
          errors.add(:base, config["forbid_save_message_#{current_locale}"] || :invalid)
          broadcast(:restore_value)
        end
      end
    end
  end
end
