# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class WordAndLinksSettingsForm < SettingsForm
        attribute :stop_list_tlds_csv, String
        attribute :stop_list_words_csv, String

        validates :stop_list_words_csv, presence: true
      end
    end
  end
end
