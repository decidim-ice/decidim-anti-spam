# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class LockSettingsForm < ActionSettingsForm
        attribute :lock_enabled, Boolean, default: true
        attribute :hide_comments_enabled, Boolean, default: false
        add_conditional_display(:hide_comments_enabled, :lock_enabled)
      end
    end
  end
end
