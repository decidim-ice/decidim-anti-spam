# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class ForbiddenTldsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm
        attribute :forbidden_tlds_csv, String
        validates :forbidden_tlds_csv, presence: true
      end
    end
  end
end
