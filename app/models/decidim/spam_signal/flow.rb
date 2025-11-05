# frozen_string_literal: true

module Decidim
  module SpamSignal
    class Flow < ApplicationRecord
      self.table_name = "anti_spam_flows"
      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"
      has_many :flow_conditions, class_name: "Decidim::SpamSignal::FlowCondition", foreign_key: :anti_spam_flow_id, dependent: :destroy
      has_many :conditions, through: :flow_conditions

      has_many :user_report_flows, foreign_key: :decidim_user_report_id, class_name: "Decidim::SpamSignal::UserReportFlow", dependent: :destroy

      validates :trigger_type, presence: true
      validates :name, presence: true

      def available_actions
        @available_actions ||= trigger.available_actions
      end

      def available_conditions
        @available_conditions ||= trigger.available_conditions
      end

      private

      def trigger
        @trigger ||= trigger_type.constantize
      end
    end
  end
end
