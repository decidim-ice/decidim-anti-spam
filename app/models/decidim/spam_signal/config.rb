# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Config < ApplicationRecord
      self.table_name = "spam_signal_config_tables"
      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      validates :organization, presence: true

      def self.get_config(organization)
        @instance ||= Config.find_or_create_by(organization: organization) do |conf|
          conf.days_before_delete = 5
          conf.validate_profile = true
          conf.validate_comments = true
          conf.stop_list_tlds = ""
          conf.stop_list_words = ""
        end
      end
    end
  end
end
