# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class HideActionCommand < ActionCommand
        def call
          return broadcast(:save) unless config["hide_enabled"]

          current_locale = normalize_locale(I18n.locale || current_organization.default_locale)
          errors.add(:topbar, config["hide_message_#{current_locale}"] || :invalid)
          errors.add(:page, config["hide_forbiden_page_message_#{current_locale}"] || :invalid)
          broadcast(:done)
        end
      end
    end
  end
end
