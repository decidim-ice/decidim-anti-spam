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
      selected = options.find { |_value, key| key.to_s == selected_value }.last || nil
      options_for_select(options, selected: selected)
    end
  end
end
