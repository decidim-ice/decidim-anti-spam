# frozen_string_literal: true

module Decidim
  module SpamSignal
    class WordAndLinksScanForm < StrategyForm
      attribute :stop_list_tlds_csv, String
      attribute :stop_list_words_csv, String

      validates :stop_list_words, presence: true
    end
  end
end
