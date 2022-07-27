# frozen_string_literal: true

module Decidim::SpamSignal::Admin
  module SpamSignalHelper
    def quarantine
      @quarantine
    end
    def to_ban
      Decidim::SpamSignal::BannedUser.to_ban
    end
    def banned
      Decidim::SpamSignal::BannedUser.banned_users
    end
  end
end
