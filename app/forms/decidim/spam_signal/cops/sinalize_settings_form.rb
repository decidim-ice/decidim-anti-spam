# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class SinalizeSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm
        attribute :forbid_creation_enabled, Boolean, default: true
      end
    end
  end
end
