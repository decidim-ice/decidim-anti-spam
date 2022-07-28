# frozen_string_literal: true

module Decidim
  module SpamSignal
    class ConfigForm < Decidim::Form
      mimic :config
      attribute :days_before_delete, Integer
      attribute :validate_profile, Boolean
      attribute :validate_comments, Boolean
      attribute :stop_list_tlds, String
      attribute :stop_list_words, String

      validates :stop_list_words, presence: true
    end
  end
end
