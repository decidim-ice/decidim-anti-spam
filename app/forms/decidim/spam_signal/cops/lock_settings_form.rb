# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class LockSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm
        attribute :forbid_creation_enabled, Boolean, default: true
        attribute :sinalize_user_enabled, Boolean, default: true
        attribute :hide_comments_enabled, Boolean, default: false
      end
    end
  end
end
