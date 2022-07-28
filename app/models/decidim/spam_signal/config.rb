# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Config < ApplicationRecord
      self.table_name = "spam_signal_config_tables"
      def self.get_config
        @instance ||= Config.first || Config.create!(
          days_before_delete: 5,
          validate_profile: true,
          validate_comments: true,
          stop_list_tlds: "",
          stop_list_words: ""
        )
      end
    end
  end
end
