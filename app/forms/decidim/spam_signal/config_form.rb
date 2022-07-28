# frozen_string_literal: true

module Decidim
  module SpamSignal
    class ConfigForm < Decidim::Form
      mimic :config
      attribute :days_before_delete, Integer
      attribute :profile_scan, String
      attribute :stop_list_tlds, String
      attribute :stop_list_words, String

      validates :stop_list_words, presence: true
    end
  end
end
