# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Cops
      class LockSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm
        attribute :is_email_unlockable, Boolean
      end
    end
  end
end
