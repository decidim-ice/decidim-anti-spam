# frozen_string_literal: true

module Decidim
  module SpamSignal
    class UserReportFlow < ApplicationRecord
      self.table_name = "user_report_flows"

      belongs_to :user_report, foreign_key: :decidim_user_report_id, class_name: "Decidim::UserReport"
      belongs_to :flow, foreign_key: :anti_spam_flows_id, class_name: "Decidim::SpamSignal::Flow"
    end
  end
end
