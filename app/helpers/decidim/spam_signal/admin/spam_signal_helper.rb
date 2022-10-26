# frozen_string_literal: true

module Decidim::SpamSignal::Admin
  module SpamSignalHelper
    def routes
      Decidim::SpamSignal::AdminEngine.routes.url_helpers
    end
    def cops_list(selected_value)
      options = Decidim::SpamSignal::Cops::CopsRepository.instance.strategies.map do |key, value|
        [t("#{value.i18n_key}.name"), key]
      end
      selected = options.find { |value, key| "#{key}" == selected_value }.last || nil
      options_for_select(options, selected: selected)
    end
    def to_ban
      Decidim::SpamSignal::BannedUser.to_ban(@current_organization)
    end
    def banned
      Decidim::SpamSignal::BannedUser.banned_users
    end
  end
end
