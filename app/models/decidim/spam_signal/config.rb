# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Config < ApplicationRecord
      self.table_name = "spam_signal_config_tables"
      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      validates :organization, presence: true
      before_save :compute_settings
      def self.get_config(organization)
        Config.find_or_create_by!(organization: organization) do |conf|
          conf.comment_settings = {}
          conf.profile_settings = {}
        end
      end

      def comments
        @comment_repo ||= SpamConfigRepo.new("comments", self, self.comment_settings)
      end

      def profiles
        @profile_repo ||= SpamConfigRepo.new("profiles", self, self.profile_settings)
      end

      def save_settings
        comment_settings_will_change!
        profile_settings_will_change!
        save!
      end

      private
        def compute_settings
          self.comment_settings = {
            "scans" => comments.scans,
            "rules" => comments.rules,
            "spam_cop" => comments.spam_cop,
            "suspicious_cop" => comments.suspicious_cop
          }
          self.profile_settings = {
            "scans" => profiles.scans,
            "rules" => profiles.rules,
            "spam_cop" => profiles.spam_cop,
            "suspicious_cop" => profiles.suspicious_cop
          }
        end
    end
  end
end
