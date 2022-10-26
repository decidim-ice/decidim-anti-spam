# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class WordSettingsForm < Decidim::Form
        include Decidim::SpamSignal::SettingsForm
        attribute :stop_list_words_csv, String
        validates :stop_list_words_csv, presence: true
      end
    end
  end
end
