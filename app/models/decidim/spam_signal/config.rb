# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Config < ApplicationRecord
      self.table_name = "spam_signal_config_tables"
      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      validates :organization, presence: true
      validate :valid_cops
      validate :valid_scanners

      def self.get_config(organization)
        @instance ||= Config.find_or_create_by(organization: organization) do |conf|
          conf.days_before_delete = 5

          conf.profile_scan = "none"
          conf.comment_scan = "none"

          conf.profile_obvious_cop = "none"
          conf.profile_suspicious_cop = "none"
          conf.comment_obvious_cop = "none"
          conf.comment_suspicious_cop = "none"

          conf.scan_settings = {
            "none": {},
            "word_and_links": {},
          }

          conf.cops_settings = {
            "none": {},
            "quarantine": {}
          }
        end
      end

      def for_scan(scan_name)
        scan_key = "#{scan_name}"
        return {} if scan_settings.empty?
        return {} unless scan_settings.key? scan_key
        ActiveSupport::HashWithIndifferentAccess.new(
          scan_settings[scan_key]
        )
      end
      
      def for_cop(scan_name)
        scan_key = "#{scan_name}"
        return {} if cops_settings.empty?
        return {} unless cops_settings.key? scan_key
        ActiveSupport::HashWithIndifferentAccess.new(
          cops_settings[scan_key]
        )
      end

      private
        def valid_cops
          # TODO validate cops options from available strategies
        end

        def valid_scanners
          # TODO validate scanners options from available strategies
        end
    end
  end
end
