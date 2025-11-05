# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Overrides
      module UserReportOverrides
        extend ActiveSupport::Concern

        included do
          has_many :user_report_flows, foreign_key: :decidim_user_report_id, class_name: "Decidim::SpamSignal::UserReportFlow", dependent: :destroy
          has_many :flows, through: :user_report_flows, class_name: "Decidim::SpamSignal::Flow"
        end
      end
    end
  end
end
