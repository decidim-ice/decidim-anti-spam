# frozen_string_literal: true

module Decidim
  module SpamSignal
    class NoSettingsForm < Decidim::Form
      include Decidim::SpamSignal::SettingsForm
    end
  end
end
