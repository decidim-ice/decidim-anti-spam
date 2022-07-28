# frozen_string_literal: true

module Decidim::SpamSignal::Admin
  module SpamSignalHelper
    def quarantine
      @quarantine
    end
    def scanners_list
      options_for_select SpamScannerStrategiesService.instance.services.map do |key, value|
        [value.name, key]
      end
    end
    def to_ban
      Decidim::SpamSignal::BannedUser.to_ban(@current_organization)
    end
    def banned
      Decidim::SpamSignal::BannedUser.banned_users
    end
  end
end
