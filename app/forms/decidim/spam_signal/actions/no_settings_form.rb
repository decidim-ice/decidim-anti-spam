# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Actions
      class NoSettingsForm < ActionSettingsForm
        include Decidim::SpamSignal::SettingsForm
      end
    end
  end
end
